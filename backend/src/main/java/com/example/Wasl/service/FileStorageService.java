package com.example.Wasl.service;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.example.Wasl.dto.AttachmentDTO;
import com.example.Wasl.entity.ApartmentListing;
import com.example.Wasl.entity.ListingAttachment;
import com.example.Wasl.entity.TransportSubscription;
import com.example.Wasl.entity.enums.AttachmentType;
import com.example.Wasl.repository.ApartmentListingRepository;
import com.example.Wasl.repository.ListingAttachmentRepository;
import com.example.Wasl.repository.TransportSubscriptionRepository;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FileStorageService {

    @Value("${file.upload-dir:./uploads}")
    private String uploadDir;

    private Path uploadPath;

    private final ListingAttachmentRepository attachmentRepository;
    private final ApartmentListingRepository apartmentRepo;
    private final TransportSubscriptionRepository transportRepo;

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10 MB
    private static final List<String> ALLOWED_EXTENSIONS = List.of(
            "jpg", "jpeg", "png", "pdf", "webp");

    @PostConstruct
    public void init() {
        uploadPath = Paths.get(uploadDir).toAbsolutePath().normalize();
        try {
            Files.createDirectories(uploadPath);
        } catch (IOException e) {
            throw new RuntimeException("لا يمكن إنشاء مجلد الرفع: " + uploadPath, e);
        }
    }

    // ── Upload for Apartment Listing ────────────────────────────────

    @Transactional
    public AttachmentDTO uploadForApartment(UUID listingId, UUID providerId,
            MultipartFile file, AttachmentType fileType) {

        ApartmentListing listing = apartmentRepo.findById(listingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "الإعلان غير موجود"));

        if (!listing.getProviderProfile().getId().equals(providerId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "لا يمكنك رفع ملفات لخدمة لا تملكها");
        }

        String storedFileName = storeFile(file);

        ListingAttachment attachment = ListingAttachment.builder()
                .apartmentListing(listing)
                .fileUrl("/api/files/" + storedFileName)
                .fileName(file.getOriginalFilename())
                .fileType(fileType)
                .fileSize(file.getSize())
                .build();

        attachment = attachmentRepository.save(attachment);
        return toDTO(attachment);
    }

    // ── Upload for Transport Subscription ───────────────────────────

    @Transactional
    public AttachmentDTO uploadForTransport(UUID subscriptionId, UUID providerId,
            MultipartFile file, AttachmentType fileType) {

        TransportSubscription sub = transportRepo.findById(subscriptionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "الاشتراك غير موجود"));

        if (!sub.getProviderProfile().getId().equals(providerId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "لا يمكنك رفع ملفات لخدمة لا تملكها");
        }

        String storedFileName = storeFile(file);

        ListingAttachment attachment = ListingAttachment.builder()
                .transportSubscription(sub)
                .fileUrl("/api/files/" + storedFileName)
                .fileName(file.getOriginalFilename())
                .fileType(fileType)
                .fileSize(file.getSize())
                .build();

        attachment = attachmentRepository.save(attachment);
        return toDTO(attachment);
    }

    // ── Get Attachments ─────────────────────────────────────────────

    @Transactional(readOnly = true)
    public List<AttachmentDTO> getApartmentAttachments(UUID listingId) {
        return attachmentRepository.findByApartmentListing_Id(listingId)
                .stream().map(this::toDTO).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<AttachmentDTO> getTransportAttachments(UUID subscriptionId) {
        return attachmentRepository.findByTransportSubscription_Id(subscriptionId)
                .stream().map(this::toDTO).collect(Collectors.toList());
    }

    // ── Delete Attachment ────────────────────────────────────────────

    @Transactional
    public void deleteAttachment(UUID attachmentId, UUID providerId) {
        ListingAttachment attachment = attachmentRepository.findById(attachmentId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "الملف غير موجود"));

        // Verify ownership
        UUID ownerId = null;
        if (attachment.getApartmentListing() != null) {
            ownerId = attachment.getApartmentListing().getProviderProfile().getId();
        } else if (attachment.getTransportSubscription() != null) {
            ownerId = attachment.getTransportSubscription().getProviderProfile().getId();
        }

        if (ownerId == null || !ownerId.equals(providerId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "لا يمكنك حذف ملفات لخدمة لا تملكها");
        }

        // Delete physical file
        String fileName = attachment.getFileUrl().replace("/api/files/", "");
        try {
            Path filePath = uploadPath.resolve(fileName);
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            // Log but don't fail — DB record removal is more important
        }

        attachmentRepository.delete(attachment);
    }

    // ── Load File for Serving ───────────────────────────────────────

    public Resource loadFile(String fileName) {
        try {
            Path filePath = uploadPath.resolve(fileName).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (resource.exists() && resource.isReadable()) {
                return resource;
            } else {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "الملف غير موجود: " + fileName);
            }
        } catch (MalformedURLException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "الملف غير موجود: " + fileName);
        }
    }

    // ── Helpers ─────────────────────────────────────────────────────

    private String storeFile(MultipartFile file) {
        if (file.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "الملف فارغ");
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "حجم الملف يتجاوز الحد المسموح (10 MB)");
        }

        String originalFileName = file.getOriginalFilename();
        String extension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            extension = originalFileName.substring(originalFileName.lastIndexOf(".") + 1).toLowerCase();
        }

        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "نوع الملف غير مسموح. الأنواع المسموحة: " + String.join(", ", ALLOWED_EXTENSIONS));
        }

        // Generate unique file name to prevent collisions
        String storedFileName = UUID.randomUUID().toString() + "." + extension;

        try {
            Path targetPath = uploadPath.resolve(storedFileName);
            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, targetPath, StandardCopyOption.REPLACE_EXISTING);
            }
            return storedFileName;
        } catch (IOException e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                    "فشل في حفظ الملف: " + e.getMessage());
        }
    }

    private AttachmentDTO toDTO(ListingAttachment attachment) {
        return AttachmentDTO.builder()
                .id(attachment.getId())
                .fileUrl(attachment.getFileUrl())
                .fileName(attachment.getFileName())
                .fileType(attachment.getFileType().name())
                .fileSize(attachment.getFileSize())
                .createdAt(attachment.getCreatedAt())
                .build();
    }
}
