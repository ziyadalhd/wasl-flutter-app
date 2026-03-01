package com.example.Wasl.service;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.example.Wasl.dto.ApartmentListingDTO;
import com.example.Wasl.dto.CreateApartmentListingRequest;
import com.example.Wasl.dto.CreateTransportSubscriptionRequest;
import com.example.Wasl.dto.TransportSubscriptionDTO;
import com.example.Wasl.entity.ApartmentListing;
import com.example.Wasl.entity.ProviderProfile;
import com.example.Wasl.entity.TransportSubscription;
import com.example.Wasl.entity.enums.AccommodationType;
import com.example.Wasl.entity.enums.ListingStatus;
import com.example.Wasl.entity.enums.SubscriptionDuration;
import com.example.Wasl.entity.enums.VehicleType;
import com.example.Wasl.repository.ApartmentListingRepository;
import com.example.Wasl.repository.ProviderProfileRepository;
import com.example.Wasl.repository.TransportSubscriptionRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ServiceListingService {

    private final ApartmentListingRepository apartmentRepo;
    private final TransportSubscriptionRepository transportRepo;
    private final ProviderProfileRepository providerProfileRepo;

    // ── Apartment Listings ──────────────────────────────────────────

    @Transactional
    public ApartmentListingDTO createApartmentListing(UUID providerId, CreateApartmentListingRequest request) {
        ProviderProfile provider = getProviderProfile(providerId);

        ApartmentListing listing = ApartmentListing.builder()
                .providerProfile(provider)
                .title(request.getTitle())
                .accommodationType(AccommodationType.valueOf(request.getAccommodationType()))
                .city(request.getCity())
                .location(request.getLocation())
                .description(request.getDescription())
                .rooms(request.getRooms())
                .bathrooms(request.getBathrooms())
                .facilities(request.getFacilities())
                .capacity(request.getCapacity())
                .subscriptionDuration(SubscriptionDuration.valueOf(request.getSubscriptionDuration()))
                .price(request.getPrice())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .status(ListingStatus.PENDING_REVIEW)
                .build();

        listing = apartmentRepo.save(listing);
        return toApartmentDTO(listing);
    }

    @Transactional
    public ApartmentListingDTO updateApartmentListing(UUID providerId, UUID listingId,
            CreateApartmentListingRequest request) {
        ApartmentListing listing = apartmentRepo.findById(listingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "الإعلان غير موجود"));

        verifyOwnership(listing.getProviderProfile().getId(), providerId);

        listing.setTitle(request.getTitle());
        listing.setAccommodationType(AccommodationType.valueOf(request.getAccommodationType()));
        listing.setCity(request.getCity());
        listing.setLocation(request.getLocation());
        listing.setDescription(request.getDescription());
        listing.setRooms(request.getRooms());
        listing.setBathrooms(request.getBathrooms());
        listing.setFacilities(request.getFacilities());
        listing.setCapacity(request.getCapacity());
        listing.setSubscriptionDuration(SubscriptionDuration.valueOf(request.getSubscriptionDuration()));
        listing.setPrice(request.getPrice());
        listing.setStartDate(request.getStartDate());
        listing.setEndDate(request.getEndDate());
        // Reset to pending review after edit
        listing.setStatus(ListingStatus.PENDING_REVIEW);

        listing = apartmentRepo.save(listing);
        return toApartmentDTO(listing);
    }

    @Transactional(readOnly = true)
    public Page<ApartmentListingDTO> getMyApartmentListings(UUID providerId, Pageable pageable) {
        return apartmentRepo.findByProviderProfile_IdOrderByCreatedAtDesc(providerId, pageable)
                .map(this::toApartmentDTO);
    }

    @Transactional(readOnly = true)
    public Page<ApartmentListingDTO> getActiveApartmentListings(Pageable pageable) {
        return apartmentRepo.findByStatusOrderByCreatedAtDesc(ListingStatus.ACTIVE, pageable)
                .map(this::toApartmentDTO);
    }

    @Transactional(readOnly = true)
    public Page<ApartmentListingDTO> getPendingApartmentListings(Pageable pageable) {
        return apartmentRepo.findByStatusOrderByCreatedAtDesc(ListingStatus.PENDING_REVIEW, pageable)
                .map(this::toApartmentDTO);
    }

    @Transactional
    public void deleteApartmentListing(UUID providerId, UUID listingId) {
        ApartmentListing listing = apartmentRepo.findById(listingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "الإعلان غير موجود"));

        verifyOwnership(listing.getProviderProfile().getId(), providerId);
        apartmentRepo.delete(listing);
    }

    @Transactional
    public ApartmentListingDTO updateApartmentListingStatus(UUID listingId, ListingStatus status) {
        ApartmentListing listing = apartmentRepo.findById(listingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "الإعلان غير موجود"));

        listing.setStatus(status);
        listing = apartmentRepo.save(listing);
        return toApartmentDTO(listing);
    }

    // ── Transport Subscriptions ─────────────────────────────────────

    @Transactional
    public TransportSubscriptionDTO createTransportSubscription(UUID providerId,
            CreateTransportSubscriptionRequest request) {
        ProviderProfile provider = getProviderProfile(providerId);

        TransportSubscription sub = TransportSubscription.builder()
                .providerProfile(provider)
                .name(request.getName())
                .vehicleType(VehicleType.valueOf(request.getVehicleType()))
                .vehicleModel(request.getVehicleModel())
                .vehicleYear(request.getVehicleYear())
                .plateNumber(request.getPlateNumber())
                .seats(request.getSeats())
                .city(request.getCity())
                .departureLocation(request.getDepartureLocation())
                .universityLocation(request.getUniversityLocation())
                .subscriptionDuration(SubscriptionDuration.valueOf(request.getSubscriptionDuration()))
                .price(request.getPrice())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .status(ListingStatus.PENDING_REVIEW)
                .build();

        sub = transportRepo.save(sub);
        return toTransportDTO(sub);
    }

    @Transactional
    public TransportSubscriptionDTO updateTransportSubscription(UUID providerId, UUID subscriptionId,
            CreateTransportSubscriptionRequest request) {
        TransportSubscription sub = transportRepo.findById(subscriptionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "الاشتراك غير موجود"));

        verifyOwnership(sub.getProviderProfile().getId(), providerId);

        sub.setName(request.getName());
        sub.setVehicleType(VehicleType.valueOf(request.getVehicleType()));
        sub.setVehicleModel(request.getVehicleModel());
        sub.setVehicleYear(request.getVehicleYear());
        sub.setPlateNumber(request.getPlateNumber());
        sub.setSeats(request.getSeats());
        sub.setCity(request.getCity());
        sub.setDepartureLocation(request.getDepartureLocation());
        sub.setUniversityLocation(request.getUniversityLocation());
        sub.setSubscriptionDuration(SubscriptionDuration.valueOf(request.getSubscriptionDuration()));
        sub.setPrice(request.getPrice());
        sub.setStartDate(request.getStartDate());
        sub.setEndDate(request.getEndDate());
        // Reset to pending review after edit
        sub.setStatus(ListingStatus.PENDING_REVIEW);

        sub = transportRepo.save(sub);
        return toTransportDTO(sub);
    }

    @Transactional(readOnly = true)
    public Page<TransportSubscriptionDTO> getMyTransportSubscriptions(UUID providerId, Pageable pageable) {
        return transportRepo.findByProviderProfile_IdOrderByCreatedAtDesc(providerId, pageable)
                .map(this::toTransportDTO);
    }

    @Transactional(readOnly = true)
    public Page<TransportSubscriptionDTO> getActiveTransportSubscriptions(Pageable pageable) {
        return transportRepo.findByStatusOrderByCreatedAtDesc(ListingStatus.ACTIVE, pageable)
                .map(this::toTransportDTO);
    }

    @Transactional(readOnly = true)
    public Page<TransportSubscriptionDTO> getPendingTransportSubscriptions(Pageable pageable) {
        return transportRepo.findByStatusOrderByCreatedAtDesc(ListingStatus.PENDING_REVIEW, pageable)
                .map(this::toTransportDTO);
    }

    @Transactional
    public void deleteTransportSubscription(UUID providerId, UUID subscriptionId) {
        TransportSubscription sub = transportRepo.findById(subscriptionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "الاشتراك غير موجود"));

        verifyOwnership(sub.getProviderProfile().getId(), providerId);
        transportRepo.delete(sub);
    }

    @Transactional
    public TransportSubscriptionDTO updateTransportSubscriptionStatus(UUID subscriptionId, ListingStatus status) {
        TransportSubscription sub = transportRepo.findById(subscriptionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "الاشتراك غير موجود"));

        sub.setStatus(status);
        sub = transportRepo.save(sub);
        return toTransportDTO(sub);
    }

    // ── Helpers ─────────────────────────────────────────────────────

    private ProviderProfile getProviderProfile(UUID userId) {
        return providerProfileRepo.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "ملف مقدم الخدمة غير موجود. تأكد أن حسابك مسجل كمقدم خدمة"));
    }

    private void verifyOwnership(UUID ownerId, UUID requesterId) {
        if (!ownerId.equals(requesterId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "لا يمكنك التعديل على خدمة لا تملكها");
        }
    }

    private ApartmentListingDTO toApartmentDTO(ApartmentListing listing) {
        return ApartmentListingDTO.builder()
                .id(listing.getId())
                .title(listing.getTitle())
                .accommodationType(listing.getAccommodationType() != null
                        ? listing.getAccommodationType().name()
                        : null)
                .city(listing.getCity())
                .location(listing.getLocation())
                .description(listing.getDescription())
                .rooms(listing.getRooms())
                .bathrooms(listing.getBathrooms())
                .facilities(listing.getFacilities())
                .capacity(listing.getCapacity())
                .subscriptionDuration(listing.getSubscriptionDuration() != null
                        ? listing.getSubscriptionDuration().name()
                        : null)
                .price(listing.getPrice())
                .startDate(listing.getStartDate())
                .endDate(listing.getEndDate())
                .status(listing.getStatus() != null ? listing.getStatus().name() : null)
                .providerName(listing.getProviderProfile() != null
                        && listing.getProviderProfile().getUser() != null
                                ? listing.getProviderProfile().getUser().getFullName()
                                : null)
                .providerId(listing.getProviderProfile() != null
                        ? listing.getProviderProfile().getId()
                        : null)
                .createdAt(listing.getCreatedAt())
                .build();
    }

    private TransportSubscriptionDTO toTransportDTO(TransportSubscription sub) {
        return TransportSubscriptionDTO.builder()
                .id(sub.getId())
                .name(sub.getName())
                .vehicleType(sub.getVehicleType() != null ? sub.getVehicleType().name() : null)
                .vehicleModel(sub.getVehicleModel())
                .vehicleYear(sub.getVehicleYear())
                .plateNumber(sub.getPlateNumber())
                .seats(sub.getSeats())
                .city(sub.getCity())
                .departureLocation(sub.getDepartureLocation())
                .universityLocation(sub.getUniversityLocation())
                .subscriptionDuration(sub.getSubscriptionDuration() != null
                        ? sub.getSubscriptionDuration().name()
                        : null)
                .price(sub.getPrice())
                .startDate(sub.getStartDate())
                .endDate(sub.getEndDate())
                .status(sub.getStatus() != null ? sub.getStatus().name() : null)
                .providerName(sub.getProviderProfile() != null
                        && sub.getProviderProfile().getUser() != null
                                ? sub.getProviderProfile().getUser().getFullName()
                                : null)
                .providerId(sub.getProviderProfile() != null
                        ? sub.getProviderProfile().getId()
                        : null)
                .createdAt(sub.getCreatedAt())
                .build();
    }
}
