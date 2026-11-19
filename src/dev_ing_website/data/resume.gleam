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
  ResumeData(
    name: "Callum Ingley",
    headline: "Full-Stack Software Engineer — Web, Mobile & Functional Systems",
    location: "Newcastle, NSW",
    email: "callum.ingley@gmail.com",
    github_url: "https://github.com/kazlim-code",
    summary: "Software engineer with experience across full-stack TypeScript web platforms, cross-platform mobile apps, cloud services, and functional programming in Gleam. Always learning and exploring modern developer tooling such as Git and Jujutsu (jj) to build clean, reliable software.",
    skill_groups: [
      SkillGroup(category: "Languages", skills: [
        "Gleam",
        "TypeScript",
        "JavaScript",
        "SQL",
        "Swift",
        "Kotlin",
      ]),
      SkillGroup(category: "Web & Mobile", skills: [
        "Lustre",
        "Wisp",
        "Vue",
        "Nuxt",
        "Capacitor",
        "Tailwind CSS",
        "HTML5 & CSS3",
      ]),
      SkillGroup(category: "Backend, Cloud & Data", skills: [
        "BEAM / Erlang",
        "Mist",
        "PostgreSQL",
        "AWS",
        "AWS Amplify",
      ]),
      SkillGroup(category: "Tooling & Practices", skills: [
        "Jujutsu (jj)",
        "Git",
        "GitHub / GitLab",
        "Storybook",
        "TDD & Snapshot Testing",
        "Neovim",
      ]),
    ],
    experience: [
      ExperienceRole(
        company: "Grafa",
        role: "Software Engineer",
        period: "2025 – 2026",
        location: "Australia (Remote)",
        highlights: [
          "Delivered full-stack web features and financial data views in TypeScript and Nuxt",
          "Collaborated on backend API integration, PostgreSQL queries, and AWS workflows",
          "Improved maintainability with modular component patterns and automated checks",
        ],
        technologies: ["TypeScript", "Nuxt", "Vue", "PostgreSQL", "AWS"],
      ),
      ExperienceRole(
        company: "Wyrd Technology",
        role: "Software Engineer",
        period: "2024 – 2025",
        location: "Australia (Remote)",
        highlights: [
          "Built cross-platform web and mobile applications using Vue, TypeScript, and Capacitor",
          "Implemented native iOS and Android bridge integrations in Swift, Kotlin, and Xcode",
          "Streamlined release pipelines and UI consistency across mobile form factors",
        ],
        technologies: [
          "TypeScript",
          "Vue",
          "Capacitor",
          "Swift",
          "Kotlin",
          "Xcode",
        ],
      ),
      ExperienceRole(
        company: "Grafa",
        role: "Full-Stack Developer",
        period: "2021 – 2024",
        location: "Perth / Newcastle, Australia",
        highlights: [
          "Engineered core web application features and reusable UI components with Storybook",
          "Worked across AWS Amplify, PostgreSQL, and REST APIs tested with Postman",
          "Partnered with product and design teams using Jira and Confluence",
        ],
        technologies: [
          "TypeScript",
          "JavaScript",
          "Vue",
          "Nuxt",
          "PostgreSQL",
          "AWS Amplify",
          "Storybook",
        ],
      ),
      ExperienceRole(
        company: "Akora Property",
        role: "Software & Systems Contributor",
        period: "2018 – 2020",
        location: "Perth, WA",
        highlights: [
          "Supported web tooling, structured data management, and operational workflows",
          "Automated reporting and internal process improvements across property operations",
        ],
        technologies: ["JavaScript", "HTML5 & CSS3", "Git"],
      ),
      ExperienceRole(
        company: "The West Australian",
        role: "Digital Production & Technical Operations",
        period: "2010 – 2018",
        location: "Perth, WA",
        highlights: [
          "Contributed to high-cadence digital publishing and production workflows",
          "Collaborated across multidisciplinary editorial and technical teams under strict deadlines",
        ],
        technologies: ["Web Publishing", "Digital Media", "Team Collaboration"],
      ),
    ],
    education: [
      EducationEntry(
        institution: "The University of Western Australia (UWA)",
        qualification: "Bachelor of Science — Computer & Mathematical Sciences",
        period: "Perth, WA",
      ),
    ],
  )
}
