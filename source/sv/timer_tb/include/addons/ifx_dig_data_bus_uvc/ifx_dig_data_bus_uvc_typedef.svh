/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */
 
typedef enum int {READ=0, WRITE=1, INVALID_READ=3, INVALID_WRITE=4} access_type_t;
typedef enum int {ADDR_INVALID=1, ADDR_VALID=0} address_validity_t;