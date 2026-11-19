//// Pure data definitions for Callum Ingley's Living Resume (`/resume`).
////

/// Represents a professional engineering or career role.
///
pub type ExperienceRole {
  ExperienceRole(
    company: String,
    role: String,
    period: String,
    location: String,
    highlights: List(String),
    technologies: List(String),
  )
}

/// Groups related technical skills by domain.
///
pub type SkillGroup {
  SkillGroup(category: String, skills: List(String))
}

/// Represents an academic qualification.
///
pub type EducationEntry {
  EducationEntry(institution: String, qualification: String, period: String)
}

/// Full Living Resume data structure.
///
pub type ResumeData {
  ResumeData(
    name: String,
    headline: String,
    location: String,
    email: String,
    github_url: String,
    summary: String,
    skill_groups: List(SkillGroup),
    experience: List(ExperienceRole),
    education: List(EducationEntry),
  )
}

/// Returns Callum Ingley's structured Living Resume data.
///
pub fn callum_resume() -> ResumeData {
  todo as "Stage 1A stub: callum_resume"
}
