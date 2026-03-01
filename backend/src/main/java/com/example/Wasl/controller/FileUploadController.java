package com.example.Wasl.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.Wasl.dto.AttachmentDTO;
import com.example.Wasl.entity.enums.AttachmentType;
import com.example.Wasl.service.FileStorageService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class FileUploadController {

    private final FileStorageService fileStorageService;

    // ── Upload for Apartment ────────────────────────────────────────

    @PostMapping("/services/apartments/{listingId}/attachments")
    public ResponseEntity<AttachmentDTO> uploadApartmentAttachment(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID listingId,
            @RequestParam("file") MultipartFile file,
            @RequestParam("fileType") String fileType) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        AttachmentType type = AttachmentType.valueOf(fileType.toUpperCase());

        AttachmentDTO dto = fileStorageService.uploadForApartment(listingId, providerId, file, type);
        return ResponseEntity.status(HttpStatus.CREATED).body(dto);
    }

    // ── Upload for Transport ────────────────────────────────────────

    @PostMapping("/services/transport/{subscriptionId}/attachments")
    public ResponseEntity<AttachmentDTO> uploadTransportAttachment(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID subscriptionId,
            @RequestParam("file") MultipartFile file,
            @RequestParam("fileType") String fileType) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        AttachmentType type = AttachmentType.valueOf(fileType.toUpperCase());

        AttachmentDTO dto = fileStorageService.uploadForTransport(subscriptionId, providerId, file, type);
        return ResponseEntity.status(HttpStatus.CREATED).body(dto);
    }

    // ── Get Attachments ─────────────────────────────────────────────

    @GetMapping("/services/apartments/{listingId}/attachments")
    public ResponseEntity<List<AttachmentDTO>> getApartmentAttachments(@PathVariable UUID listingId) {
        return ResponseEntity.ok(fileStorageService.getApartmentAttachments(listingId));
    }

    @GetMapping("/services/transport/{subscriptionId}/attachments")
    public ResponseEntity<List<AttachmentDTO>> getTransportAttachments(@PathVariable UUID subscriptionId) {
        return ResponseEntity.ok(fileStorageService.getTransportAttachments(subscriptionId));
    }

    // ── Delete Attachment ───────────────────────────────────────────

    @DeleteMapping("/services/attachments/{attachmentId}")
    public ResponseEntity<Void> deleteAttachment(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID attachmentId) {

        UUID providerId = UUID.fromString(userDetails.getUsername());
        fileStorageService.deleteAttachment(attachmentId, providerId);
        return ResponseEntity.noContent().build();
    }

    // ── Serve Files (Public) ────────────────────────────────────────

    @GetMapping("/files/{fileName:.+}")
    public ResponseEntity<Resource> serveFile(@PathVariable String fileName) {
        Resource file = fileStorageService.loadFile(fileName);

        String contentType = "application/octet-stream";
        if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
            contentType = "image/jpeg";
        } else if (fileName.endsWith(".png")) {
            contentType = "image/png";
        } else if (fileName.endsWith(".webp")) {
            contentType = "image/webp";
        } else if (fileName.endsWith(".pdf")) {
            contentType = "application/pdf";
        }

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + fileName + "\"")
                .body(file);
    }
}
