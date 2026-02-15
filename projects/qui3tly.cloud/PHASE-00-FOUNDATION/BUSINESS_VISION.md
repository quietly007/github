# BUSINESS VISION
## qui3tly.cloud - Professional Infrastructure Services

**Document Version**: 1.0  
**Date**: February 15, 2026  
**Purpose**: Define the business model, service offerings, target market, and value proposition for qui3tly.cloud

---

## 1. COMPANY OVERVIEW

### 1.1 Identity

**Company Name**: qui3tly.cloud  
**Brand Element**: "3" as distinctive element (not "quietly" but "qui3tly")  
**Owner**: Tihomir Raznatović (qui3tly)  
**Location**: Montenegro  
**Domains**: 
- qui3tly.cloud (brand, marketing)
- quietly.its.me (primary services)
- quietly.online (email services)

### 1.2 Founder Background

**Tihomir Raznatović**:
- 30+ years networking and Linux experience
- Founded first ISP in Montenegro (1995) - **Internet Crna Gora**
- Former Chief Specialist for Internet Access
- Managed AS8585 (Autonomous System)
- RIPE IPv4 block: 195.66.160.0/19 (8,192 IPs) - first in Montenegro
- Handover to T-Com (Deutsche Telekom) March 2010
- ISP-grade expertise applied to modern cloud infrastructure

**AI Partner**: "Lucky Luke" (Claude Opus 4.5 via GitHub Copilot)
- Named after Belgian comic character (shoots faster than his shadow)
- Full infrastructure autonomy
- Partnership: "30 years human expertise + AI precision = A+++ infrastructure"
- Nickname: "The A+++ Destroyer Partnership"

### 1.3 Mission & Vision

**Mission**: 
*"Deliver professional, secure, and reliable infrastructure services that combine ISP-grade reliability with enterprise security, while maintaining simplicity and customer control."*

**Vision**:
*"Be the trusted infrastructure platform for small to medium businesses in Montenegro and beyond, offering enterprise-grade services without vendor lock-in or unnecessary complexity."*

**Core Values**:
- **Excellence**: A+++ grade infrastructure, no compromises
- **Security**: Defense in depth, proactive threat management
- **Reliability**: ISP-grade uptime and disaster recovery
- **Transparency**: Clear documentation, honest communication
- **Simplicity**: Complex infrastructure, simple user experience

---

## 2. BUSINESS MODEL

### 2.1 Service Offerings

**Core Infrastructure Services**:

1. **Managed Infrastructure Hosting**
   - Virtual Private Servers (VPS) with full management
   - Container-based architecture (Docker)
   - High-availability configurations
   - 24/7 monitoring and alerting
   - Proactive maintenance

2. **Email Hosting & Communication**
   - Complete Mailcow stack (18 containers)
   - Webmail (SOGo), calendars, contacts
   - Spam filtering (Rspamd with custom rules)
   - Multiple domain support
   - Mobile sync (ActiveSync, IMAP)

3. **VPN & Network Solutions**
   - Tailscale mesh VPN (zero-trust networking)
   - WireGuard site-to-site tunnels
   - Multi-site connectivity
   - Secure remote access
   - Network management (UniFi, UISP)

4. **Cloud Storage & Collaboration**
   - Nextcloud file sync and share
   - Office suite integration (OnlyOffice/Collabora)
   - Team collaboration features
   - Mobile apps (iOS, Android)
   - On-premise or hosted

5. **Monitoring & Observability**
   - Complete monitoring stack (Prometheus, Grafana, Loki)
   - Custom dashboards per customer
   - Alert management (Alertmanager, Gotify)
   - Log aggregation and analysis
   - Uptime monitoring (Uptime Kuma)

6. **Security Services**
   - Intrusion Prevention (CrowdSec with community rules)
   - Fail2ban automated blocking
   - Two-factor authentication (Authelia)
   - SSL/TLS certificate management
   - Regular security audits

7. **Disaster Recovery & Backup**
   - Automated backup strategies
   - Multiple recovery methods (2min, 15min, 45min RTO)
   - Tested procedures (100% success rate)
   - Documentation and runbooks
   - Recovery time objectives (RTO) guaranteed

8. **Business Applications** *(Planned/In Development)*
   - Accounting systems (Odoo/ERPNext)
   - Inventory management
   - Customer relationship management (CRM)
   - Enterprise resource planning (ERP)
   - Custom application hosting

9. **Surveillance & Physical Security** *(Planned)*
   - CCTV/NVR systems (Frigate/Shinobi)
   - 80+ camera support mentioned
   - Alarm management (DSC Powermanage)
   - Access control integration
   - Remote viewing and recording

10. **Custom Development** *(Planned)*
    - Mobile app development (iOS/Android)
    - API integrations
    - Workflow automation
    - Custom business logic

### 2.2 Target Market

**Primary Target**: Small to Medium Businesses (SMBs) in Montenegro

**Characteristics**:
- 10-100 employees
- Need professional IT infrastructure but can't afford in-house IT teams
- Value data sovereignty (want data in Montenegro, not US cloud)
- Require reliability but flexible on features
- Budget-conscious but understand value of uptime
- Industries: Manufacturing, retail, professional services, hospitality

**Secondary Target**: Individual professionals and consultants
- Doctors, lawyers, accountants
- Need secure email and document storage
- Compliance requirements (GDPR, professional secrecy)
- Simple management, high security

**Example Customer**: **MONTEFISH**
- Fish processing company, Montenegro
- 4 geographic locations (Tivat, Budva, Ribnjak, Carina)
- 4 enterprise servers planned (Master, Lady, Beauty, Madam)
- Comprehensive IT transformation project
- Contact: Miloš Vučelić (Operations Manager) +382 68 076512

**Project "Norma"**: 
- Mentioned in Q2-Q3 2026 roadmap
- Nextcloud-based solution
- Documentation exists (norma-nextcloud-quickstart.md, norma-onlyoffice-guide.md)
- Status: Planned deployment

### 2.3 Competitive Positioning

**vs. Global Cloud Providers (AWS, Azure, Google Cloud)**:
- **Advantage**: Personal service, local support, data sovereignty, no vendor lock-in
- **Advantage**: Transparent pricing, no surprise bills
- **Advantage**: Montenegro data residency (legal/compliance benefits)
- **Disadvantage**: Limited global reach, smaller scale

**vs. Local Hosting Companies (Pegasus, Opera3)**:
- **Advantage**: Custom solutions (not templates or cPanel)
- **Advantage**: ISP-grade expertise (30 years Tihomir experience)
- **Advantage**: Modern container architecture (not legacy VMs)
- **Advantage**: Complete monitoring and security (not just hosting)
- **Comparable**: Pricing likely similar

**vs. DIY / Self-Hosting**:
- **Advantage**: Professional management, 24/7 monitoring
- **Advantage**: Disaster recovery tested and guaranteed
- **Advantage**: Security expertise (CrowdSec, fail2ban, Authelia)
- **Advantage**: Save employee time (focus on business, not IT)
- **Disadvantage**: Higher cost than pure DIY

**Unique Selling Proposition (USP)**:
*"ISP-grade reliability meets modern cloud infrastructure, managed by 30 years of networking expertise, with data in Montenegro and zero vendor lock-in."*

---

## 3. REVENUE MODEL

### 3.1 Pricing Structure (Proposed)

**Note**: Current documentation does NOT explicitly define pricing. This section proposes structure based on service offerings.

**Model 1: Monthly Managed Service Fee (Per Server)**
- **Tier 1**: Single VPS, basic services (email, VPN, monitoring) - €150-200/month
- **Tier 2**: Multi-server, advanced services (DR, security) - €300-400/month
- **Tier 3**: Enterprise, custom services (CCTV, apps) - €500-800/month
- **Tier 4**: Montefish-scale (4+ servers, multiple locations) - €1,200-1,800/month

**Model 2: Per-Location Pricing**
- Base: €200/month per location
- Additional services: €50-150/month each
- Multi-site discount: 10-20% for 3+ locations

**Model 3: Per-User Pricing**
- Base infrastructure: €50/month
- Per user: €10-15/month (email, storage, apps)
- Minimum 10 users
- Example: 25 users = €50 + (25 × €12) = €350/month

**One-Time Fees**:
- **Setup/Onboarding**: €500-1,500 (depends on complexity)
- **Custom Development**: €50-100/hour (apps, integrations)
- **Consulting**: €75/hour (planning, architecture)
- **Migration**: €1,000-3,000 (from existing infrastructure)

**Add-On Services**:
- CCTV/NVR: €200-500/month (depends on camera count)
- Advanced monitoring: €100/month
- Priority support: €150/month
- Compliance audit: €500/audit

### 3.2 Revenue Streams

**Recurring Revenue** (Target 80-90% of revenue):
- Monthly managed services
- Per-user subscriptions
- Add-on services

**Project Revenue** (Target 10-20% of revenue):
- Setup and onboarding
- Custom development
- Consulting and architecture
- Migration projects

**Target Revenue** (12 months after project launch):
- 5-10 customers at €300-500/month = €1,500-5,000/month
- 2-3 enterprise customers at €800-1,200/month = €1,600-3,600/month
- Consulting/projects: €1,000-2,000/month
- **Total Target**: €4,100-10,600/month (€50,000-125,000/year)

### 3.3 Cost Structure

**Fixed Costs** (Monthly):
- VPS hosting (2 servers): ~€80-100/month (Contabo)
- Domains and SSL: ~€10/month
- Tools and subscriptions: ~€20/month
- **Total Fixed**: ~€110-130/month

**Variable Costs**:
- Additional VPS per customer: €40-80/server/month
- Storage expansion: €10-30/TB/month
- Bandwidth overages: Pay as needed
- Subcontractors (for specialized work): €50-75/hour

**Labor Costs**:
- Tihomir (owner): Time investment (currently no salary, reinvest in growth)
- External consultants: As needed for specialized work
- AI tools (GitHub Copilot): €10-20/month

**Gross Margin Target**: 60-70% (after VPS and infrastructure costs)

---

## 4. CUSTOMER VALUE PROPOSITION

### 4.1 Customer Benefits

**For SMB Customers**:
1. **Focus on Business**: Let qui3tly.cloud handle IT, you handle customers
2. **Predictable Cost**: Monthly fee, no surprises
3. **Local Support**: Montenegro-based, same timezone, šta treba odgovorimo
4. **Data Sovereignty**: Data stays in Montenegro (legal/compliance advantage)
5. **Enterprise-Grade**: Same quality as big companies pay for, SMB price
6. **Proven Expertise**: 30 years ISP experience, not a startup learning

**For Compliance-Sensitive Businesses**:
1. **GDPR Compliance**: Data in EU (Montenegro candidate), not US
2. **Professional Secrecy**: Secure email for lawyers, doctors, accountants
3. **Audit Trail**: Complete logs and monitoring
4. **Disaster Recovery**: Documented and tested procedures
5. **Security**: Multiple layers of protection

**For Technical Customers**:
1. **No Vendor Lock-In**: Open-source stack, portable to any VPS
2. **Full Access**: SSH access, complete control if needed
3. **Transparency**: Complete documentation, runbooks provided
4. **Modern Architecture**: Container-based, not legacy VMs
5. **Monitoring**: Grafana dashboards, see your infrastructure health

### 4.2 Customer Pain Points Addressed

**Pain Point 1**: "IT is too expensive for our size"
- **Solution**: Monthly fee affordable for SMBs, scales with business

**Pain Point 2**: "We can't find good IT staff in Montenegro"  
- **Solution**: You don't need staff, qui3tly.cloud manages everything

**Pain Point 3**: "Big cloud providers confusing and expensive"
- **Solution**: Simple packages, transparent pricing, local support

**Pain Point 4**: "Worried about data in US/China clouds"
- **Solution**: Data in Montenegro, German datacenter (Contabo), EU jurisdiction

**Pain Point 5**: "Current IT provider doesn't understand our business"
- **Solution**: Personalized service, discuss your needs directly with owner

**Pain Point 6**: "Downtime costs us money but IT doesn't prioritize uptime"
- **Solution**: 99.9% uptime target, proactive monitoring, DR tested

---

## 5. GO-TO-MARKET STRATEGY

### 5.1 Customer Acquisition

**Phase 1** (Current): Pilot & Reference Customers
- Deploy Montefish (4 servers, multiple locations)
- Deploy Project Norma
- Document case studies
- Build portfolio

**Phase 2** (6 months): Direct Sales
- Personal network in Montenegro business community
- Consulting engagements → managed services
- Word of mouth from satisfied customers
- LinkedIn outreach to SMB decision makers

**Phase 3** (12 months): Marketing & Scale
- Website with case studies and pricing
- Partner with business consultants in Montenegro
- Industry events and conferences
- Content marketing (blog, guides, tutorials)

### 5.2 Sales Process

**Step 1**: Initial Contact (phone, email, referral)
**Step 2**: Discovery Meeting (understand needs, current infrastructure)
**Step 3**: Proposal (services, pricing, timeline)
**Step 4**: Pilot/Trial (1-3 months, limited services)
**Step 5**: Full Deployment (migrate all services)
**Step 6**: Ongoing Management (monthly fee, regular reviews)

### 5.3 Customer Success

**Onboarding**:
- Documented procedures (customer onboarding guide)
- Initial training (2-4 hours, key users)
- Documentation handoff (runbooks, credentials)
- Monitoring setup (alerts to customer email/Slack)

**Ongoing**:
- Monthly reports (uptime, performance, incidents)
- Quarterly reviews (in-person or video call)
- 24/7 monitoring (proactive issue detection)
- Response time SLA (1 hour critical, 4 hours normal)

**Retention**:
- Excellent service (minimize downtime, fast response)
- Transparent communication (no surprises)
- Regular improvements (software updates, new features)
- Fair pricing (no surprise price increases)

---

## 6. TEAM STRUCTURE

### 6.1 Current Team

**Leadership**:
- **Tihomir Raznatović (qui3tly)**: Founder, Chief Architect, Primary Contact
- **Natalia Danilova**: Office Manager, +382 69 244466

**Operations** (from Montefish proposal):
- **Miloš Vučelić**: Operations Manager, +382 68 076512
- **Nikola Martinović**: Security Specialist, +382 68 740904
- **Davorin Popović**: Physical Security, +382 67 857000

**Technical**:
- **Ivan Đukić**: IT Engineer, +382 68 767086
- **Žarko Velimirović**: Electronics Technician, +382 68 048222

**External Consultants**:
- **Pridon Otarashvili**: Consultant, +7 925 3352000

**AI Partners**:
- **Lucky Luke**: GitHub Copilot (Claude Opus 4.5), Infrastructure automation and documentation

### 6.2 Roles & Responsibilities

**Tihomir (qui3tly)**:
- Business development and sales
- Architecture and design decisions
- Customer relationships (primary contact)
- Strategic planning
- Quality assurance and approvals

**Operations Team**:
- Customer onboarding and training
- Issue escalation and response
- Physical security (for on-premise components)
- Project management

**Technical Team**:
- Infrastructure implementation
- Monitoring and maintenance
- Issue resolution (technical)
- Customer support (technical)

**Lucky Luke (AI)**:
- Documentation and automation
- Monitoring and alerting
- Infrastructure as code
- Repetitive tasks automation

### 6.3 Growth Plan

**6 Months**: Add 1 technical engineer (as customer base grows)  
**12 Months**: Add customer success manager (5+ customers)  
**18 Months**: Add sales/marketing person (scale customer acquisition)

---

## 7. STRATEGIC OBJECTIVES (12 Months)

### 7.1 Infrastructure Objectives

1. ✅ **Production Ready (90/100 A+++)**: Complete this 9-phase project
2. 🎯 **Customer Readiness**: Deploy Montefish and Norma successfully
3. 🎯 **Service Completeness**: Office suite, accounting, CCTV operational
4. 🎯 **Documentation Excellence**: Complete runbooks and customer guides
5. 🎯 **Monitoring Maturity**: Dashboards for all customers, proactive alerts

### 7.2 Business Objectives

1. 🎯 **Revenue Target**: €50,000-125,000 first year
2. 🎯 **Customer Target**: 5-10 SMB customers by 12 months
3. 🎯 **Reference Customers**: 2-3 case studies documented
4. 🎯 **Brand Establishment**: Logo, website, marketing materials
5. 🎯 **Profitability**: Break-even by month 6, profitable by month 12

### 7.3 Technical Objectives

1. 🎯 **Multi-Site Capability**: Support 4+ locations per customer (Montefish model)
2. 🎯 **Service Expansion**: Add CCTV/NVR, mobile apps
3. 🎯 **Automation**: Ansible for all deployments, self-service where possible
4. 🎯 **Compliance**: GDPR audit, security certifications
5. 🎯 **Redundancy**: Multi-datacenter option for critical customers

---

## 8. SUCCESS METRICS

### 8.1 Infrastructure Metrics

- **Uptime**: 99.9% target (43 minutes downtime/month allowed)
- **RTO**: 2/15/45 minutes for 3 DR methods
- **Security**: Zero successful intrusions, <1% false positive alerts
- **Performance**: <200ms average response time for web services
- **Grade**: Maintain 90/100 (A+++) after achieving

### 8.2 Business Metrics

- **Customer Count**: 5-10 by month 12
- **Customer Retention**: >90% annual retention rate
- **Revenue**: €50,000-125,000 year 1
- **Customer Satisfaction**: >4.5/5 average rating
- **Response Time**: <1 hour for critical issues, <4 hours normal

### 8.3 Operational Metrics

- **Onboarding Time**: <30 days from sale to production
- **Incident Response**: <1 hour acknowledge, <4 hours resolve (critical)
- **Documentation**: 100% of services documented
- **Backup Success**: 100% automated backup success rate
- **Training**: 100% of customers trained on key services

---

## 9. RISKS & MITIGATION

### 9.1 Business Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Slow customer acquisition | High | Start with pilot customers (Montefish, Norma) |
| Pricing too high for market | High | Flexible packages, pilot pricing |
| Competition from big clouds | Medium | Focus on local support, data sovereignty |
| Customer churn | High | Excellent service, transparent communication |
| Can't find technical staff | Medium | Automation (Ansible), AI assistance (Lucky Luke) |

### 9.2 Technical Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Infrastructure failure | High | DR tested, 3 recovery methods |
| Security breach | High | Defense in depth, regular audits |
| Contabo datacenter issue | Medium | Backup provider option, multi-datacenter future |
| Single person dependency (Tihomir) | High | Documentation, procedures, train team members |
| Technology obsolescence | Medium | Modern stack, container-based, upgradeable |

---

## 10. CONCLUSION

qui3tly.cloud combines **30 years of ISP and networking expertise** with **modern container-based infrastructure** to deliver **enterprise-grade services to small and medium businesses in Montenegro**.

**Key Differentiators**:
- ISP-grade reliability (not hobbyist or startup)
- Local support and data sovereignty
- Modern architecture (containers, not legacy)
- Transparent pricing and no vendor lock-in
- Proven disaster recovery (tested 100% success)

**Target**: 5-10 customers in 12 months, €50,000-125,000 revenue, profitable by month 12.

**Current Focus**: Complete this 9-phase project to achieve 90/100 (A+++) production readiness, then deploy pilot customers (Montefish, Norma) as reference implementations for future sales.

---

**Document Version**: 1.0  
**Prepared By**: Lucky Luke (Primary Agent) based on audit findings  
**Date**: February 15, 2026  
**Status**: Draft - Awaiting user review and approval  
**Next Action**: User reviews and confirms business vision accuracy
