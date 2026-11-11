## Sample pedigrees for the tests copied from nprcgenekeepr: exact copies of
## nprcgenekeepr's datasets of the same names at nprcgenekeepr commit
## baef1e12c, saved by tools/makeTestFixtures.R (Mark's pick in S3: test
## files, not package datasets).
## pedOne (Phase 7, S8) is read by test_kinshipHasBothParentsHelp.R. Five
## Phase 6b test files type a data frame of their own named pedOne, which
## shadows this one inside those files.
## examplePedigree, pedWithGenotype and rhesusPedigree (Phase 8, S9) are read
## by the layout engine's tests. Those tests also read three of
## nprcgenekeepr's inst/extdata/examples/obfuscated_rhesus_mhc_*.csv files,
## copied byte for byte into fixtures/ at the same commit.
examplePedigree <- readRDS(test_path("fixtures", "examplePedigree.rds"))
lacy1989Ped <- readRDS(test_path("fixtures", "lacy1989Ped.rds"))
pedOne <- readRDS(test_path("fixtures", "pedOne.rds"))
pedSix <- readRDS(test_path("fixtures", "pedSix.rds"))
pedWithGenotype <- readRDS(test_path("fixtures", "pedWithGenotype.rds"))
qcPed <- readRDS(test_path("fixtures", "qcPed.rds"))
rhesusPedigree <- readRDS(test_path("fixtures", "rhesusPedigree.rds"))
smallPed <- readRDS(test_path("fixtures", "smallPed.rds"))
