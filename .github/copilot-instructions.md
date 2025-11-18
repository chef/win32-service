# GitHub Copilot Instructions for win32-service

## Purpose
This document defines the authoritative operational workflow for AI assistants contributing to the win32-service Ruby gem repository. This gem provides a Ruby interface to Windows services, allowing creation, control, configuration, and inspection of services on MS Windows systems.

## Repository Structure
```
win32-service/
├── .expeditor/                # Expeditor release automation configs
│   ├── config.yml            # Release automation configuration
│   ├── scripts/              # Release automation scripts
│   ├── update_version.sh     # Version update script
│   └── verify.pipeline.yml   # Expeditor pipeline config
├── .github/
│   ├── CODEOWNERS           # Code ownership definitions
│   ├── ISSUE_TEMPLATE.md    # Issue template
│   ├── PULL_REQUEST_TEMPLATE.md # PR template
│   ├── prompts/             # AI assistant prompts
│   └── workflows/           # GitHub Actions CI/CD
│       ├── lint.yml         # RuboCop linting workflow
│       └── unit.yml         # Unit testing workflow
├── doc/                     # Documentation files
│   ├── daemon.txt          # Daemon class documentation
│   └── service.txt         # Service class documentation
├── examples/               # Example usage scripts
│   ├── demo_daemon_ctl.rb  # Daemon control example
│   ├── demo_daemon.rb      # Daemon implementation example
│   ├── demo_services.rb    # Service management example
│   └── show_load_path.rb   # Load path demonstration
├── lib/                    # Main library code
│   ├── win32-daemon.rb     # Daemon functionality
│   ├── win32-service.rb    # Service functionality
│   └── win32/              # Core implementation
│       ├── daemon.rb       # Daemon class
│       ├── service.rb      # Service class
│       └── windows/        # Windows-specific code
│           ├── constants.rb # Windows constants
│           ├── functions.rb # Windows API functions
│           ├── structs.rb  # Windows structures
│           └── version.rb  # Version information
├── spec/                   # RSpec test files
│   └── unit/               # Unit tests
│       └── win32/
│           └── service_spec.rb # Service class specs
├── tasks/                  # Rake task definitions
│   └── rspec.rb           # RSpec task configuration
├── test/                   # Test-Unit test files
│   ├── test_win32_daemon.rb                    # Daemon tests
│   ├── test_win32_service_close_service_handle.rb # Service handle tests
│   ├── test_win32_service_configure.rb         # Service config tests
│   ├── test_win32_service_create.rb           # Service creation tests
│   ├── test_win32_service_info.rb             # Service info tests
│   ├── test_win32_service_status.rb           # Service status tests
│   └── test_win32_service.rb                  # General service tests
├── win32-service.gemspec   # Gem specification
├── Gemfile                 # Bundle dependencies
├── Rakefile               # Rake tasks
├── README.md              # Project documentation
├── CHANGELOG.md           # Version history
├── VERSION               # Current version
└── .ruby-version         # Ruby version specification
```

## Tooling & Ecosystem
- **Language**: Ruby (>= 3.1)
- **Testing Frameworks**: RSpec and Test::Unit
- **Linting**: RuboCop with Cookstyle/ChefStyle configuration
- **Dependencies**: FFI for Windows API integration
- **Platform**: Windows-specific (Windows 2022, Windows 2025)
- **Package Manager**: Bundler/RubyGems
- **Release Automation**: Expeditor
- **CI/CD**: GitHub Actions

## Issue (Jira/Tracker) Integration
When an issue key is supplied:
1. Parse summary, description, and acceptance criteria
2. Generate Implementation Plan including:
   - Goal
   - Impacted Files
   - Public API/Interface Changes
   - Data/Integration Considerations
   - Test Strategy
   - Edge Cases
   - Risks & Mitigations
   - Rollback Strategy
3. MUST freeze code changes until user approves plan with "yes"
4. If acceptance criteria absent → prompt user to confirm inferred criteria

## Workflow Overview
Phases (MUST follow in order):
1. **Intake & Clarify** - Understand requirements and scope
2. **Repository Analysis** - Examine codebase structure and dependencies
3. **Plan Draft** - Create detailed implementation plan
4. **Plan Confirmation** - Get explicit user approval (gate)
5. **Incremental Implementation** - Make smallest cohesive changes
6. **Lint / Style** - Ensure RuboCop compliance
7. **Test & Coverage Validation** - Verify test coverage ≥80%
8. **DCO Commit** - Commit with Developer Certificate of Origin
9. **Push & Draft PR Creation** - Create draft pull request
10. **Label & Risk Application** - Apply appropriate GitHub labels
11. **Final Validation** - Verify all criteria met

Each phase ends with: Step Summary + Checklist + "Continue to next step? (yes/no)".

## Detailed Step Instructions
**Principles (MUST):**
- Smallest cohesive change per commit
- Add/adjust tests immediately with each behavior change
- Present mapping of changes to tests before committing

**Example Step Output:**
```
Step: Add boundary guard in parser
Summary: Added nil check & size constraint; tests added for empty input & overflow.
Checklist:
- [x] Plan
- [x] Implementation
- [ ] Tests
Proceed? (yes/no)
```

If user responds other than explicit "yes" → AI MUST pause & clarify.

## Branching & PR Standards
- **Branch Naming (MUST)**: EXACT issue key if provided; else kebab-case slug (≤40 chars)
- **One logical change set per branch (MUST)**
- **PR MUST remain draft until**: tests pass + lint/style pass + coverage mapping completed
- **Risk Classification (MUST pick one)**:
  - Low: Localized, non-breaking
  - Moderate: Shared module / light interface touch
  - High: Public API change / performance / security / migration
- **Rollback Strategy (MUST)**: revert commit \<SHA\> or feature toggle reference

## Commit & DCO Policy
**Commit format (MUST):**
```
{{TYPE}}({{OPTIONAL_SCOPE}}): {{SUBJECT}} ({{ISSUE_KEY}})

Rationale (what & why).

Issue: <ISSUE_KEY or none>
Signed-off-by: Full Name <email@domain>
```

Missing sign-off → block and request name/email.

## Testing & Coverage
**Changed Logic → Test Assertions Mapping (MUST):**
| File | Method/Block | Change Type | Test File | Assertion Reference |

**Coverage Threshold (MUST)**: ≥80% changed lines
If below: add tests or refactor for testability.

**Edge Cases (MUST enumerate for each plan):**
- Large input / boundary size
- Empty / nil input
- Invalid / malformed data
- Platform-specific differences (Windows versions, permissions)
- Concurrency / timing (if applicable)
- External dependency failures (Windows API, service dependencies)

## Labels Reference
| Name | Description | Typical Use |
|------|-------------|-------------|
| Aspect: Documentation | How do we use this project? | Documentation updates |
| Aspect: Integration | Works correctly with other projects or systems | Integration changes |
| Aspect: Packaging | Distribution of the projects 'compiled' artifacts | Gem packaging |
| Aspect: Performance | Works without negatively affecting the system | Performance improvements |
| Aspect: Portability | Does this project work correctly on the specified platform? | Platform compatibility |
| Aspect: Security | Can an unwanted third party affect stability or access privileged information? | Security fixes |
| Aspect: Stability | Consistent results | Bug fixes, stability improvements |
| Aspect: Testing | Does the project have good coverage, and is CI working? | Test-related changes |
| Aspect: UI | How users interact with the interface | User interface changes |
| Aspect: UX | How users feel interacting with the project | User experience improvements |
| Expeditor: Bump Version Major | Used by github.major_bump_labels to bump the Major version number | Breaking changes |
| Expeditor: Bump Version Minor | Used by github.minor_bump_labels to bump the Minor version number | New features |
| Expeditor: Skip All | Used to skip all merge_actions | Skip all automation |
| Expeditor: Skip Changelog | Used to skip built_in:update_changelog | Skip changelog update |
| Expeditor: Skip Habitat | Used to skip built_in:trigger_habitat_package_build | Skip Habitat build |
| Expeditor: Skip Omnibus | Used to skip built_in:trigger_omnibus_release_build | Skip Omnibus build |
| Expeditor: Skip Version Bump | Used to skip built_in:bump_version | Skip version bump |
| hacktoberfest-accepted | A PR that has been accepted for credit in the Hacktoberfest project | Hacktoberfest |
| oss-standards | Related to OSS Repository Standardization | OSS compliance |
| Platform: AWS | null | AWS-specific |
| Platform: Azure | null | Azure-specific |
| Platform: Linux | null | Linux-specific |
| Platform: macOS | null | macOS-specific |

## CI / Release Automation Integration
**GitHub Actions Workflows:**
- `lint.yml`: RuboCop linting with Cookstyle/ChefStyle configuration, triggered on PRs and main branch pushes
- `unit.yml`: Unit testing on Windows 2022/2025 with Ruby 3.1/3.4 matrix, triggered on PRs and main branch pushes

**Release Automation:**
- Expeditor handles version bumping, changelog updates, and release builds
- Version bump mechanism: Expeditor labels trigger automated version updates
- Configuration in `.expeditor/config.yml`

**AI MUST NOT directly edit release automation configs without explicit user instruction.**

## Security & Protected Files
**Protected (NEVER edit without explicit approval):** LICENSE, CODE_OF_CONDUCT*, CODEOWNERS, SECURITY*, release automation configs (.expeditor/), CI workflow files (.github/workflows/), secrets, credential placeholders, compliance policy docs.

**NEVER:**
- Exfiltrate or inject secrets
- Force-push default branch
- Merge PR autonomously
- Insert new binaries
- Remove license headers
- Fabricate issue or label data
- Reference `~/.profile` in auth guidance

## Prompts Pattern
After each step AI MUST output:
```
Step: {{STEP_NAME}}
Summary: {{CONCISE_OUTCOME}}
Checklist: markdown list of phases with status
Prompt: "Continue to next step? (yes/no)"
```

Non-affirmative response → AI MUST pause & clarify.

## Validation & Exit Criteria
Task is COMPLETE ONLY IF:
1. Feature/fix branch exists & pushed
2. Lint/style passes (RuboCop with Cookstyle)
3. Tests pass (including platform-guarded tests for Windows)
4. Coverage mapping complete + ≥80% changed lines
5. PR open (draft or ready) with required sections
6. Appropriate labels applied
7. All commits DCO-compliant
8. No unauthorized Protected File modifications
9. User explicitly confirms completion

Otherwise AI MUST list unmet items.

## Issue Planning Template
```
Issue: ABC-123
Summary: <from issue>
Acceptance Criteria:
- ...
Implementation Plan:
- Goal:
- Impacted Files:
- Public API Changes:
- Data/Integration Considerations:
- Test Strategy:
- Edge Cases:
- Risks & Mitigations:
- Rollback:
Proceed? (yes/no)
```

## PR Description Canonical Template
The repository has an existing `.github/PULL_REQUEST_TEMPLATE.md` template. AI MUST use this template as the base structure and inject required additional sections (Tests & Coverage mapping details, Risk & Mitigations, DCO confirmation) within or appended beneath existing headings.

The existing template includes:
- Description
- Issues Resolved
- Check List (with DCO requirement)

Additional required sections to inject:
- Tests & Coverage: Changed lines: N; Estimated covered: ~X%; Mapping complete
- Risk & Mitigations: Risk: Low/Moderate/High | Mitigation: revert commit SHA

## Idempotency Rules
**Re-entry Detection Order (MUST):**
1. Branch existence (`git rev-parse --verify <branch>`)
2. PR existence (`gh pr list --head <branch>`)
3. Uncommitted changes (`git status --porcelain`)

**Delta Summary (MUST):**
- Added Sections:
- Modified Sections:
- Deprecated Sections:
- Rationale:

## Failure Handling
**Decision Tree (MUST):**
- Labels fetch fails → Abort; prompt: "Provide label list manually or fix auth. Retry? (yes/no)"
- Issue fetch incomplete → Ask: "Missing acceptance criteria—provide or proceed with inferred? (provide/proceed)"
- Coverage < threshold → Add tests; re-run; block commit until satisfied
- Missing DCO → Request user name/email
- Protected file modification attempt → Reject & restate policy

## Glossary
- **Changed Lines Coverage**: Portion of modified lines executed by assertions
- **Implementation Plan Freeze Point**: No code changes allowed until approval
- **Protected Files**: Policy-restricted assets requiring explicit user authorization
- **Idempotent Re-entry**: Resuming workflow without duplicated or conflicting state
- **Risk Classification**: Qualitative impact tier (Low/Moderate/High)
- **Rollback Strategy**: Concrete reversal action (revert commit / disable feature)
- **DCO**: Developer Certificate of Origin sign-off confirming contribution rights

## Quick Reference Commands
```bash
# Ruby gem development workflow
git checkout -b <BRANCH>
bundle install
bundle exec rubocop -c .rubocop.yml  # Lint check
bundle exec rake                     # Run tests
git add .
git commit -m "feat(component): add capability (ABC-123)" -s
git push -u origin <BRANCH>
gh pr create --base main --head <BRANCH> --title "ABC-123: Short summary" --draft
gh pr edit <PR_NUMBER> --add-label "Aspect: Enhancement"

# Windows-specific testing
bundle exec rake test              # Run Test::Unit tests
bundle exec rspec                  # Run RSpec tests
```

## AI-Assisted Development & Compliance

- ✅ Create PR with `ai-assisted` label (if label doesn't exist, create it with description "Work completed with AI assistance following Progress AI policies" and color "9A4DFF")
- ✅ Include "This work was completed with AI assistance following Progress AI policies" in PR description

### Jira Ticket Updates (MANDATORY)

- ✅ **IMMEDIATELY after PR creation**: Update Jira ticket custom field `customfield_11170` ("Does this Work Include AI Assisted Code?") to "Yes"
- ✅ Use atlassian-mcp tools to update the Jira field programmatically
- ✅ **CRITICAL**: Use correct field format: `{"customfield_11170": {"value": "Yes"}}`
- ✅ Verify the field update was successful

### Documentation Requirements

- ✅ Reference AI assistance in commit messages where appropriate
- ✅ Document any AI-generated code patterns or approaches in PR description
- ✅ Maintain transparency about which parts were AI-assisted vs manual implementation

### Workflow Integration

This AI compliance checklist should be integrated into the main development workflow Step 4 (Pull Request Creation):

```
Step 4: Pull Request Creation & AI Compliance
- Step 4.1: Create branch and commit changes WITH SIGNED-OFF COMMITS
- Step 4.2: Push changes to remote
- Step 4.3: Create PR with ai-assisted label
- Step 4.4: IMMEDIATELY update Jira customfield_11170 to "Yes"
- Step 4.5: Verify both PR labels and Jira field are properly set
- Step 4.6: Provide complete summary including AI compliance confirmation
```

- **Never skip Jira field updates** - This is required for Progress AI governance
- **Always verify updates succeeded** - Check response from atlassian-mcp tools
- **Treat as atomic operation** - PR creation and Jira updates should happen together
- **Double-check before final summary** - Confirm all AI compliance items are completed

### Audit Trail

All AI-assisted work must be traceable through:

1. GitHub PR labels (`ai-assisted`)
2. Jira custom field (`customfield_11170` = "Yes")
3. PR descriptions mentioning AI assistance
4. Commit messages where relevant
