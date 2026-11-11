## Sample pedigrees for the tests copied from nprcgenekeepr: exact copies of
## nprcgenekeepr's datasets of the same names at nprcgenekeepr commit
## baef1e12c, saved by tools/makeTestFixtures.R (Mark's pick in S3: test
## files, not package datasets).
## pedOne (Phase 7, S8) is read by test_kinshipHasBothParentsHelp.R. Five
## Phase 6b test files type a data frame of their own named pedOne, which
## shadows this one inside those files.
lacy1989Ped <- readRDS(test_path("fixtures", "lacy1989Ped.rds"))
pedOne <- readRDS(test_path("fixtures", "pedOne.rds"))
pedSix <- readRDS(test_path("fixtures", "pedSix.rds"))
qcPed <- readRDS(test_path("fixtures", "qcPed.rds"))
smallPed <- readRDS(test_path("fixtures", "smallPed.rds"))
