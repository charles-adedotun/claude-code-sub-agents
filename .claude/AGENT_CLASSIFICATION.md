# Sub-Agent Classification & Workflow Guide

> Comprehensive guide to our workflow-stage based agent ecosystem

## Overview

Our sub-agent ecosystem is organized by **workflow stages** to match the natural software development lifecycle. Each agent has specific responsibilities, decision-making authority, and collaboration patterns that ensure quality code delivery from concept to production.

## Workflow Architecture

```
📋 PLANNING → 🔨 IMPLEMENTATION → 🧪 VALIDATION → 🚀 DEPLOYMENT
     ↓              ↓                ↓              ↓
product-requirements-analyst  developers      validators    sre-devops
```

---

# 📋 PLANNING AGENTS

## product-requirements-analyst (Purple)
**Role**: Product Requirements Analyst & System Architect  
**Authority**: Advisory (no blocking power, provides specifications)  
**Stage**: Pre-implementation planning and analysis

### Primary Responsibilities
- **Requirements Analysis**: Transform business needs into technical specifications
- **System Architecture Design**: Create high-level system designs and component relationships  
- **Technology Stack Evaluation**: Research and recommend appropriate technologies
- **API Contract Design**: Define interfaces between system components
- **Non-Functional Requirements**: Specify performance, security, and scalability requirements
- **Documentation Strategy**: Create comprehensive technical documentation plans

### When to Use This Agent
- **New Feature Planning**: When starting any new feature development
- **Architecture Reviews**: When evaluating system design changes
- **Technology Decisions**: When choosing frameworks, libraries, or infrastructure
- **Requirements Clarification**: When business requirements need technical translation
- **Documentation Updates**: When creating or updating technical specifications
- **Cross-Team Coordination**: When multiple teams need aligned specifications

### Key Workflows
1. **Feature Planning Workflow**:
   - Analyze business requirements → Create technical specifications → Design system architecture → Hand off to implementation agents
   
2. **Architecture Review Workflow**:
   - Evaluate existing system → Identify improvement opportunities → Design solutions → Create implementation roadmap

3. **Documentation Workflow**:
   - Analyze system changes → Update technical documentation → Create API specifications → Maintain architecture diagrams

### Collaboration Patterns
- **Provides specifications to**: All implementation agents
- **Receives input from**: Stakeholders, business analysts, existing system analysis
- **Escalates to**: No escalation (advisory role only)
- **Works with**: All agents for requirements clarification

### Success Metrics
- Clarity and completeness of technical specifications
- Alignment between business requirements and technical solutions
- Architecture decision documentation quality
- Stakeholder understanding of technical implications

---

# 🔨 IMPLEMENTATION AGENTS

## frontend-developer (Blue)
**Role**: Frontend Implementation Specialist  
**Authority**: Code implementer (creates/modifies frontend code)  
**Stage**: UI/UX implementation with design system enforcement

### Primary Responsibilities
- **React Development**: Modern React applications with hooks and functional components
- **Design System Implementation**: Strict adherence to shadcn/ui + Tailwind v4 principles
- **Component Architecture**: Reusable, accessible, and performant UI components
- **State Management**: Client-side state with proper data flow patterns
- **Browser Compatibility**: Cross-browser testing and compatibility assurance
- **Accessibility Implementation**: WCAG 2.1 AA compliance and inclusive design

### Design System Enforcement (CRITICAL)
- **Typography**: Exactly 4 font sizes, 2 font weights (non-negotiable)
- **Spacing**: 8pt grid system (all values divisible by 8 or 4)
- **Colors**: 60/30/10 color distribution (60% neutral, 30% complementary, 10% accent)
- **Components**: shadcn/ui v4 with data-slot attributes and CVA patterns

### When to Use This Agent
- **UI Component Creation**: Building new React components or pages
- **Design System Updates**: Implementing design system changes across the application
- **Accessibility Improvements**: Enhancing UI accessibility and inclusive design
- **Performance Optimization**: Frontend performance tuning and optimization
- **Responsive Design**: Creating mobile-first, responsive interfaces
- **Browser Testing**: Cross-browser compatibility and testing

### Key Workflows
1. **Component Development Workflow**:
   - Receive design specifications → Implement with design system compliance → Test accessibility → Optimize performance → Hand off to QA

2. **Design System Migration Workflow**:
   - Audit existing components → Plan migration strategy → Implement system updates → Validate compliance → Document changes

3. **Performance Optimization Workflow**:
   - Analyze performance metrics → Identify bottlenecks → Implement optimizations → Measure improvements → Document best practices

### Collaboration Patterns
- **Receives specifications from**: product-requirements-analyst
- **Works closely with**: backend-developer (for API integration), qa-testing (for E2E testing)
- **Reviewed by**: qa-testing (functionality), security-compliance (client-side security)
- **Deploys via**: sre-devops (production deployment)

### Quality Standards
- All components must pass design system validation
- 100% keyboard navigation support
- WCAG 2.1 AA accessibility compliance
- Cross-browser compatibility (Chrome, Firefox, Safari, Edge)
- Performance budgets met (LCP < 2.5s, FID < 100ms)

---

## backend-developer (Green)
**Role**: Server-Side Implementation Specialist  
**Authority**: Code implementer (creates/modifies backend code)  
**Stage**: API, database, and server logic implementation

### Primary Responsibilities
- **API Development**: RESTful APIs, GraphQL endpoints, and service architectures
- **Database Design**: Schema design, query optimization, and data modeling
- **Security Implementation**: Authentication, authorization, and data protection
- **Performance Optimization**: Server performance, caching, and scalability
- **Integration Development**: Third-party service integrations and microservice communication
- **Error Handling**: Comprehensive error handling and logging strategies

### Multi-Language Expertise
- **Node.js/TypeScript**: Express, Fastify, Nest.js frameworks
- **Python**: FastAPI, Django, Flask applications
- **Go**: Gin, Echo, Fiber for high-performance services
- **Java**: Spring Boot enterprise applications
- **Rust**: Actix-web, Axum for systems programming

### When to Use This Agent
- **API Development**: Creating or modifying REST/GraphQL endpoints
- **Database Work**: Schema changes, query optimization, migration creation
- **Security Implementation**: Authentication systems, authorization logic, data encryption
- **Performance Tuning**: Server optimization, caching implementation, query tuning
- **Integration Development**: Third-party API integration, webhook handling
- **Microservice Architecture**: Service decomposition and inter-service communication

### Key Workflows
1. **API Development Workflow**:
   - Receive API specifications → Design database schema → Implement endpoints → Add security measures → Optimize performance → Hand off to QA

2. **Database Migration Workflow**:
   - Analyze data requirements → Design schema changes → Create migration scripts → Test data integrity → Deploy migrations → Monitor performance

3. **Security Implementation Workflow**:
   - Assess security requirements → Implement authentication/authorization → Add input validation → Configure security headers → Test vulnerabilities → Document security measures

### Collaboration Patterns
- **Receives specifications from**: product-requirements-analyst
- **Works closely with**: frontend-developer (API contracts), sre-devops (deployment)
- **Reviewed by**: security-compliance (security audit), qa-testing (functional testing)
- **Provides APIs to**: frontend-developer, external integrations

### Quality Standards
- All APIs must have OpenAPI documentation
- 100% input validation and sanitization
- Comprehensive error handling with proper HTTP status codes
- Database queries optimized with proper indexing
- Security headers and CORS properly configured
- 90%+ test coverage for business logic

---

## sre-devops (Orange)
**Role**: Site Reliability Engineer & DevOps Specialist  
**Authority**: Infrastructure implementer + deployment authority  
**Stage**: Infrastructure implementation and production deployment

### Primary Responsibilities
- **Infrastructure as Code**: Terraform, Kubernetes, Docker containerization
- **CI/CD Pipeline Engineering**: Build, test, and deployment automation
- **Monitoring & Observability**: Prometheus, Grafana, logging, and alerting systems
- **Performance & Reliability**: SLO/SLI definition, error budgets, incident response
- **Security Operations**: Infrastructure security, secrets management, compliance
- **Deployment Management**: Production deployments, rollbacks, and release coordination

### Infrastructure Expertise
- **Container Orchestration**: Kubernetes, Docker Swarm, container security
- **Cloud Platforms**: AWS, GCP, Azure service configuration and optimization
- **Monitoring Stack**: Prometheus, Grafana, ELK stack, APM tools
- **CI/CD Tools**: GitHub Actions, GitLab CI, Jenkins, ArgoCD
- **Infrastructure as Code**: Terraform, Ansible, CloudFormation

### When to Use This Agent
- **Infrastructure Setup**: New environment provisioning and configuration
- **Deployment Operations**: Production deployments, rollbacks, release management
- **Performance Issues**: System performance troubleshooting and optimization
- **Monitoring Setup**: Implementing monitoring, alerting, and observability
- **Security Hardening**: Infrastructure security improvements and compliance
- **Incident Response**: Production incident investigation and resolution

### Key Workflows
1. **Infrastructure Provisioning Workflow**:
   - Receive infrastructure requirements → Design architecture → Implement IaC → Configure monitoring → Test resilience → Document operations

2. **Deployment Pipeline Workflow**:
   - Configure CI/CD pipeline → Implement automated testing → Set up deployment stages → Configure rollback procedures → Monitor deployments

3. **Incident Response Workflow**:
   - Detect/receive incident → Assess impact → Implement immediate fix → Conduct root cause analysis → Implement preventive measures → Update runbooks

### Collaboration Patterns
- **Receives requirements from**: product-requirements-analyst (infrastructure specs), backend-developer (deployment needs)
- **Enables deployment for**: All implementation agents
- **Coordinates with**: security-compliance (infrastructure security), qa-testing (deployment testing)
- **Reports to**: Leadership on system reliability and performance

### Quality Standards
- 99.9% uptime SLO for production systems
- Infrastructure fully defined as code
- Comprehensive monitoring with alerting on all critical metrics
- Automated deployment pipelines with rollback capabilities
- Security scanning integrated into CI/CD pipeline
- Incident response time < 15 minutes for critical issues

---

# 🧪 VALIDATION AGENTS

## qa-testing (Cyan)
**Role**: Quality Assurance & Test Automation Specialist  
**Authority**: Quality gate (can block releases for quality issues)  
**Stage**: Quality validation and testing across all system components

### Primary Responsibilities
- **Test Strategy Development**: Comprehensive testing strategies and test planning
- **Automated Testing**: Unit, integration, and end-to-end test automation
- **Performance Testing**: Load testing, stress testing, and performance validation
- **Accessibility Testing**: WCAG compliance testing and inclusive design validation
- **Cross-Browser Testing**: Multi-browser and multi-device compatibility testing
- **Regression Testing**: Ensuring changes don't break existing functionality

### Testing Specializations
- **Playwright E2E Testing**: Complete browser automation and user journey testing
- **Performance Testing**: Load testing with tools like k6, JMeter, Artillery
- **API Testing**: REST/GraphQL API validation and contract testing
- **Accessibility Testing**: Automated and manual accessibility compliance testing
- **Security Testing**: Basic security testing and vulnerability scanning

### When to Use This Agent
- **Feature Testing**: New feature validation and quality assurance
- **Regression Testing**: After significant changes or before releases
- **Performance Validation**: Performance testing and optimization validation
- **Accessibility Audits**: WCAG compliance testing and accessibility improvements
- **Release Testing**: Pre-production testing and release readiness validation
- **Test Automation**: Creating and maintaining automated test suites

### Key Workflows
1. **Feature Testing Workflow**:
   - Receive feature specifications → Create test plans → Implement automated tests → Execute manual testing → Report issues → Validate fixes → Approve for release

2. **Performance Testing Workflow**:
   - Define performance requirements → Create load tests → Execute performance testing → Analyze results → Identify bottlenecks → Validate optimizations

3. **Release Testing Workflow**:
   - Execute regression test suite → Perform exploratory testing → Validate performance benchmarks → Check accessibility compliance → Approve/block release

### Collaboration Patterns
- **Tests implementations by**: All implementation agents
- **Receives test requirements from**: product-requirements-analyst
- **Works closely with**: sre-devops (deployment testing), security-compliance (security testing)
- **Blocks releases until**: Quality standards are met
- **Reports to**: Leadership on quality metrics and release readiness

### Quality Standards
- 90%+ automated test coverage for critical paths
- All accessibility standards (WCAG 2.1 AA) must pass
- Performance benchmarks must meet defined SLAs
- Zero high-severity bugs in production releases
- Cross-browser compatibility verified for all supported browsers
- Security vulnerabilities addressed before release

---

## security-compliance (Red)
**Role**: Security Auditor & Compliance Specialist  
**Authority**: Security gate (can block releases for security/compliance issues)  
**Stage**: Security validation and regulatory compliance assurance

### Primary Responsibilities
- **Security Code Review**: Vulnerability assessment and secure coding validation
- **Compliance Auditing**: Regulatory compliance verification (GDPR, HIPAA, SOC2, PCI DSS)
- **Threat Modeling**: Security risk assessment and attack vector analysis
- **Vulnerability Assessment**: Security scanning and penetration testing coordination
- **Risk Management**: Security risk evaluation and mitigation strategy development
- **Security Training**: Security awareness and best practices guidance

### Security Specializations
- **Application Security**: OWASP Top 10, secure coding practices, input validation
- **Infrastructure Security**: Container security, network security, cloud security posture
- **Compliance Frameworks**: GDPR, HIPAA, PCI DSS, SOC2, ISO27001, NIST Cybersecurity Framework
- **Risk Assessment**: STRIDE methodology, attack surface analysis, business impact assessment
- **Incident Response**: Security incident analysis and response planning

### When to Use This Agent
- **Security Reviews**: Code security audits and vulnerability assessments
- **Compliance Audits**: Regulatory compliance verification and audit preparation
- **Risk Assessments**: Security risk analysis for new features or system changes
- **Incident Analysis**: Security incident investigation and root cause analysis
- **Policy Development**: Security policy creation and compliance procedure development
- **Training & Awareness**: Security training and best practices guidance

### Key Workflows
1. **Security Review Workflow**:
   - Receive code/system for review → Conduct threat modeling → Perform vulnerability assessment → Test security controls → Report findings → Validate remediation → Approve/block release

2. **Compliance Audit Workflow**:
   - Assess compliance requirements → Review system against standards → Identify gaps → Create remediation plan → Validate implementations → Generate compliance reports

3. **Incident Response Workflow**:
   - Receive security incident → Assess impact and scope → Contain and mitigate → Investigate root cause → Implement fixes → Update security controls → Document lessons learned

### Collaboration Patterns
- **Reviews implementations by**: All implementation agents
- **Receives security requirements from**: product-requirements-analyst, regulatory requirements
- **Works closely with**: sre-devops (infrastructure security), qa-testing (security testing)
- **Escalates critical issues to**: Leadership, legal, compliance teams
- **Blocks releases until**: Security standards and compliance requirements are met

### Quality Standards
- Zero high or critical security vulnerabilities in production
- 100% compliance with applicable regulatory requirements
- All sensitive data properly encrypted in transit and at rest
- Security controls tested and validated for effectiveness
- Incident response procedures tested and documented
- Security training completed by all team members

---

## pre-commit-reviewer (Yellow)
**Role**: Code Quality Gate & Pre-Commit Analyst  
**Authority**: Commit gate (can block commits for quality/security issues)  
**Stage**: Just-in-time code quality validation before commits

### Primary Responsibilities
- **Fast Code Analysis**: 2-second analysis of code changes before commits
- **Security Vulnerability Detection**: Immediate identification of security risks
- **Code Quality Assessment**: Style, maintainability, and best practices validation
- **Performance Issue Detection**: Obvious performance problems and anti-patterns
- **Policy Compliance**: Coding standards and repository policy enforcement
- **Integration Testing**: Basic integration and compatibility checks

### Analysis Specializations
- **Security Detection**: API keys, hardcoded credentials, injection vulnerabilities
- **Code Quality**: Syntax errors, linting issues, code smells, complexity analysis
- **Performance Analysis**: O(n²) algorithms, N+1 queries, memory leaks
- **Best Practices**: Error handling, logging practices, naming conventions
- **Policy Enforcement**: File permissions, dependency policies, commit message standards

### When to Use This Agent
- **Pre-Commit Analysis**: Automatically triggered before every commit
- **Quick Code Review**: Fast feedback on code changes during development
- **Policy Enforcement**: Ensuring adherence to coding standards and repository policies
- **Security Scanning**: Immediate detection of security vulnerabilities
- **Integration Validation**: Basic compatibility and integration checks

### Key Workflows
1. **Pre-Commit Analysis Workflow**:
   - Receive git diff → Analyze changed code → Check for security issues → Validate coding standards → Report findings → Block/allow commit

2. **Security Scan Workflow**:
   - Scan for hardcoded secrets → Check for injection vulnerabilities → Validate input sanitization → Report security findings → Block commit if critical issues found

3. **Quality Gate Workflow**:
   - Check code syntax → Validate naming conventions → Assess complexity → Check error handling → Report quality issues → Provide improvement suggestions

### Collaboration Patterns
- **Analyzes commits from**: All implementation agents
- **Provides immediate feedback to**: Developers during commit process
- **Escalates complex issues to**: security-compliance, qa-testing, or relevant specialists
- **Works with**: GitPlus ship process for automated commit validation

### Quality Standards
- Analysis completed within 2 seconds
- 100% detection rate for hardcoded secrets and credentials
- Zero false positives for critical security issues
- Clear, actionable feedback for all identified issues
- Integration with existing development workflow
- Proper handling of different programming languages and frameworks

---

# Agent Interaction Patterns

## Workflow Progression
```
1. PLANNING PHASE
   product-requirements-analyst → Creates specifications and requirements

2. IMPLEMENTATION PHASE  
   frontend-developer + backend-developer + sre-devops → Build according to specs
   
3. VALIDATION PHASE
   qa-testing → Quality validation
   security-compliance → Security validation  
   pre-commit-reviewer → Commit-level validation

4. DEPLOYMENT PHASE
   sre-devops → Production deployment (with all validations passed)
```

## Escalation Paths
```
Implementation Issues → product-requirements-analyst (requirements clarification)
Quality Issues → qa-testing (testing and validation)
Security Issues → security-compliance (security review)
Infrastructure Issues → sre-devops (deployment and operations)
Critical Issues → All relevant agents + leadership
```

## Decision Authority Matrix
| Agent | Can Block Commits | Can Block Releases | Can Block Deployment |
|-------|-------------------|-------------------|---------------------|
| pre-commit-reviewer | ✅ Yes | ❌ No | ❌ No |
| qa-testing | ❌ No | ✅ Yes | ❌ No |
| security-compliance | ✅ Yes | ✅ Yes | ✅ Yes |
| sre-devops | ❌ No | ❌ No | ✅ Yes |
| Implementation agents | ❌ No | ❌ No | ❌ No |
| product-requirements-analyst | ❌ No | ❌ No | ❌ No |

## Success Metrics by Stage

### Planning Success
- Requirements clarity and completeness
- Architecture decision documentation
- Stakeholder alignment on technical approach

### Implementation Success  
- Code quality and maintainability
- Feature completeness and correctness
- Performance and security standards met

### Validation Success
- Zero high-severity bugs in production
- All quality gates passed
- Security and compliance requirements met
- Performance benchmarks achieved

### Deployment Success
- Zero-downtime deployments
- Rapid rollback capability
- Comprehensive monitoring and alerting
- System reliability and availability targets met

---

This classification ensures each agent has clear responsibilities, authority boundaries, and collaboration patterns while maintaining the flexibility to adapt to different project needs and team structures.