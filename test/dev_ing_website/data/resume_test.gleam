//// Unit tests for `dev_ing_website/data/resume` (`T06`–`T07`).
////

import dev_ing_website/data/resume
import gleam/string

/// T06: Verifies legacy typo `"such  s Git"` (B1.1) is absent from resume data.
///
/// Note (Temporary Migration Guard — S3.4): Safe to remove in future iterations
/// once v1 copy evolves beyond the legacy dev-ing port.
///
pub fn resume_summary_fixes_legacy_git_typo_test() {
  let data = resume.callum_resume()
  assert !string.contains(data.summary, "such  s Git")
}

/// T07: Verifies Living Resume data uses city/state and omits private street address or phone.
///
pub fn resume_omits_private_contact_details_test() {
  let data = resume.callum_resume()
  assert data.location == "Newcastle, NSW"
  assert !string.contains(data.location, "Bellfrog")
  assert !string.contains(data.summary, "0433")
}
