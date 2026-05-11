# Copyright IBM Corp. 2021, 2026

policy "require-all-resources-from-pmr" {
    source = "./require-all-resources-from-pmr.sentinel"
    enforcement_level = "soft-mandatory"
}
