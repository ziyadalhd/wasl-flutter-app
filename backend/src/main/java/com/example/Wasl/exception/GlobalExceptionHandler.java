package com.example.Wasl.exception;

import java.time.OffsetDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.example.Wasl.dto.ApiErrorResponse;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.security.SignatureException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

        // ── 400 Bad Request ─────────────────────────────────────────────
        @ExceptionHandler(MethodArgumentNotValidException.class)
        public ResponseEntity<ApiErrorResponse> handleValidation(
                        MethodArgumentNotValidException ex, HttpServletRequest request) {

                Map<String, String> fieldErrors = new HashMap<>();
                ex.getBindingResult().getFieldErrors()
                                .forEach(e -> fieldErrors.put(e.getField(), e.getDefaultMessage()));

                ApiErrorResponse body = new ApiErrorResponse(
                                OffsetDateTime.now(),
                                HttpStatus.BAD_REQUEST.value(),
                                "Bad Request",
                                "Validation failed",
                                request.getRequestURI(),
                                fieldErrors);

                return ResponseEntity.badRequest().body(body);
        }

        // ── 401 Unauthorized ────────────────────────────────────────────
        @ExceptionHandler(BadCredentialsException.class)
        public ResponseEntity<ApiErrorResponse> handleBadCredentials(
                        BadCredentialsException ex, HttpServletRequest request) {

                return buildResponse(HttpStatus.UNAUTHORIZED, "Unauthorized",
                                ex.getMessage(), request);
        }

        @ExceptionHandler(ExpiredJwtException.class)
        public ResponseEntity<ApiErrorResponse> handleExpiredJwt(
                        ExpiredJwtException ex, HttpServletRequest request) {

                return buildResponse(HttpStatus.UNAUTHORIZED, "Unauthorized",
                                "JWT token has expired", request);
        }

        @ExceptionHandler(SignatureException.class)
        public ResponseEntity<ApiErrorResponse> handleSignature(
                        SignatureException ex, HttpServletRequest request) {

                return buildResponse(HttpStatus.UNAUTHORIZED, "Unauthorized",
                                "Invalid JWT signature", request);
        }

        // ── 403 Forbidden ───────────────────────────────────────────────
        @ExceptionHandler(AccessDeniedException.class)
        public ResponseEntity<ApiErrorResponse> handleAccessDenied(
                        AccessDeniedException ex, HttpServletRequest request) {

                return buildResponse(HttpStatus.FORBIDDEN, "Forbidden",
                                ex.getMessage(), request);
        }

        // ── 404 Not Found ───────────────────────────────────────────────
        @ExceptionHandler(ResourceNotFoundException.class)
        public ResponseEntity<ApiErrorResponse> handleNotFound(
                        ResourceNotFoundException ex, HttpServletRequest request) {

                return buildResponse(HttpStatus.NOT_FOUND, "Not Found",
                                ex.getMessage(), request);
        }

        // ── 409 Conflict ────────────────────────────────────────────────
        @ExceptionHandler(BusinessRuleException.class)
        public ResponseEntity<ApiErrorResponse> handleBusinessRule(
                        BusinessRuleException ex, HttpServletRequest request) {

                return buildResponse(HttpStatus.CONFLICT, "Conflict",
                                ex.getMessage(), request);
        }

        @ExceptionHandler(org.springframework.dao.DataIntegrityViolationException.class)
        public ResponseEntity<ApiErrorResponse> handleDataIntegrityViolation(
                        org.springframework.dao.DataIntegrityViolationException ex, HttpServletRequest request) {

                String message = "Database error: Constraint violation";
                if (ex.getMessage() != null && ex.getMessage().contains("users_phone_key")) {
                        message = "Phone number already registered";
                } else if (ex.getMessage() != null && ex.getMessage().contains("users_email_key")) {
                        message = "Email already registered";
                }

                return buildResponse(HttpStatus.CONFLICT, "Conflict",
                                message, request);
        }

        // ── 400 Bad Request (IllegalArgumentException) ────────────────
        @ExceptionHandler(IllegalArgumentException.class)
        public ResponseEntity<ApiErrorResponse> handleIllegalArgument(
                        IllegalArgumentException ex, HttpServletRequest request) {

                return buildResponse(HttpStatus.BAD_REQUEST, "Bad Request",
                                ex.getMessage(), request);
        }

        // ── 500 Internal Server Error ───────────────────────────────────
        @ExceptionHandler(Exception.class)
        public ResponseEntity<ApiErrorResponse> handleAll(
                        Exception ex, HttpServletRequest request) {

                log.error("Unhandled exception at {}: {}", request.getRequestURI(), ex.getMessage(), ex);

                return buildResponse(HttpStatus.INTERNAL_SERVER_ERROR,
                                "Internal Server Error",
                                "Internal Server Error",
                                request);
        }

        // ── Helper ──────────────────────────────────────────────────────
        private ResponseEntity<ApiErrorResponse> buildResponse(
                        HttpStatus status, String error, String message,
                        HttpServletRequest request) {

                ApiErrorResponse body = new ApiErrorResponse(
                                OffsetDateTime.now(),
                                status.value(),
                                error,
                                message,
                                request.getRequestURI(),
                                null);

                return ResponseEntity.status(status).body(body);
        }
}
