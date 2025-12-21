# AWS Resilience Hub and Fault Injection Simulator Assessment

This document provides a critical analysis of AWS Resilience Hub and AWS Fault Injection Simulator (FIS), focusing on when these tools provide genuine value versus when they introduce unnecessary cost and complexity.

## What Are These Tools?

### AWS Resilience Hub

AWS Resilience Hub is a centralised service for assessing application resilience against defined Recovery Time Objective (RTO) and Recovery Point Objective (RPO) targets. It analyses your infrastructure configuration, compares it to AWS Well-Architected Framework best practices, and provides actionable recommendations for improvement.

**Core capabilities:**

- Automated discovery of resources via Terraform state, CloudFormation stacks, or Resource Groups
- Assessment against custom resiliency policies (AZ, regional, and application-level RTO/RPO targets)
- Compliance tracking and drift detection
- Generation of Standard Operating Procedures (SOPs) as Systems Manager documents
- Recommended CloudWatch alarms for monitoring resilience posture
- Resilience scoring for tracking improvements over time

**Pricing:** First 3 applications free for 6 months, then £15 per application per month.

### AWS Fault Injection Simulator (FIS)

AWS Fault Injection Simulator is a fully managed chaos engineering service that lets you run controlled fault injection experiments on AWS workloads. It provides built-in safety mechanisms including stop conditions based on CloudWatch alarms.

**Core capabilities:**

- Pre-built experiment templates for common failure scenarios
- Actions targeting EC2, RDS, ECS, EKS, EBS, network, and API layers
- Stop conditions acting as circuit breakers to prevent runaway failures
- Integration with CloudWatch for monitoring experiment impact
- Execution logging and reporting
- Support for custom fault injection via Systems Manager automation

**Pricing:** Pay per experiment execution based on action type and duration, plus standard AWS service charges for resources affected during experiments.

## When These Tools Provide Value

### Strong Use Cases

#### Infrastructure with architectural choices affecting resilience

Resilience Hub and FIS excel when you have decisions to make that materially impact your ability to meet RTO/RPO targets:

- **RDS databases:** Single-AZ vs Multi-AZ vs Aurora with cross-region replicas
- **EC2 compute:** Manual instance management vs Auto Scaling Groups vs multi-region deployments
- **Data persistence:** Backup strategies, replication patterns, failover procedures
- **Stateful applications:** Where data loss or extended downtime has business consequences

FIS allows you to validate that your architectural choices actually deliver the resilience you expect. For example, testing that RDS Multi-AZ failover completes within your RTO, or that your Auto Scaling Group properly replaces terminated instances under load.

#### Complex applications with recovery procedures

When you have documented runbooks or Standard Operating Procedures for failure scenarios:

- Testing that your failover procedures actually work as documented
- Validating recovery time estimates with real data
- Identifying gaps in runbooks before they matter in production
- Training operations teams on failure response

#### Compliance and regulatory requirements

When you need to demonstrate disaster recovery capabilities:

- Documented evidence of resilience testing for auditors
- Proof that RTO/RPO targets can be met
- Regular validation of backup and recovery procedures
- Tracking resilience improvements over time

#### Multi-component applications with dependencies

When failure in one component cascades to others:

- Testing circuit breakers and bulkheads
- Validating graceful degradation under partial failures
- Understanding system behaviour when dependencies are unavailable
- Identifying single points of failure in complex architectures

### Moderate Use Cases

#### Serverless applications with stateful components

Pure serverless (Lambda + API Gateway + DynamoDB) is largely managed by AWS, but you might still benefit when:

- Using RDS alongside Lambda (database configuration choices matter)
- Implementing cross-region failover for global applications
- Testing complex Step Functions workflows under component failures
- Validating DynamoDB Global Tables failover behaviour

The value here is lower than traditional infrastructure but not zero. Consider whether the cost justifies the validation.

## When These Tools Are Probably Overkill

### Weak Use Cases

#### Fully managed serverless with no architectural choices

Applications built entirely on managed services with built-in high availability:

- Static websites (S3 + CloudFront)
- Simple APIs (API Gateway + Lambda + DynamoDB)
- Event-driven architectures (EventBridge + Lambda + SQS)

These services already provide multi-AZ resilience automatically. Resilience Hub would find little to recommend beyond enabling optional features like versioning or point-in-time recovery. FIS experiments would mostly validate AWS's infrastructure, not your architecture.

**Better approach:** Focus on data resilience (versioning, backups) and deployment resilience (can you rebuild from source control?).

#### Non-critical internal applications

Applications where downtime is inconvenient but not costly:

- Internal tools with small user bases
- Development and testing environments
- Proof-of-concept applications
- Low-traffic personal projects

The cost of Resilience Hub and the effort of running FIS experiments likely exceeds the value gained. Simple monitoring and basic backup procedures are usually sufficient.

#### Applications with naturally high tolerance to failure

Systems designed to be eventually consistent or tolerant of temporary unavailability:

- Asynchronous batch processing with retry logic
- Data pipelines that can replay from checkpoints
- Cache layers where misses are acceptable
- Analytics platforms where slight delays don't matter

While you could assess and test these, the return on investment is questionable when the application already handles failures gracefully by design.

## Decision Framework

Use this framework to determine if Resilience Hub and FIS are appropriate for your application:

### Ask These Questions

#### Do you have meaningful architectural choices?

- Yes: Multi-AZ vs single, backup strategies, failover patterns → **Strong candidate**
- No: Fully managed services with no configuration options → **Weak candidate**

#### What is the cost of downtime?

- High: Revenue loss, customer impact, SLA penalties → **Strong candidate**
- Low: Minor inconvenience, easily deferred work → **Weak candidate**

#### Do you have recovery procedures to validate?

- Yes: Documented runbooks, manual failover steps → **Strong candidate for FIS**
- No: Automatic recovery, no operator intervention needed → **Consider alternatives**

#### Are there compliance requirements?

- Yes: Need to demonstrate DR capabilities → **Strong candidate for both**
- No: Internal application, no regulatory oversight → **Evaluate cost vs benefit**

#### Is the application stateful?

- Yes: Data loss or corruption has consequences → **Strong candidate**
- No: Stateless, can be rebuilt from source → **Probably overkill**

### Cost-Benefit Calculation

For each application, estimate:

**Costs:**

- Resilience Hub: £15/month per application
- FIS experiments: Variable based on frequency and scope
- Engineering time: Setup, experiment design, analysis
- Risk: Potential impact of experiments on production

**Benefits:**

- Reduced downtime duration and frequency
- Faster incident response through validated procedures
- Compliance evidence and audit trail
- Increased confidence in resilience posture

If benefits clearly outweigh costs, proceed. If marginal, consider simpler alternatives.

## Alternatives to Consider

Before committing to Resilience Hub and FIS, evaluate whether simpler approaches meet your needs:

**For assessment:**

- Manual Well-Architected Framework reviews
- AWS Trusted Advisor (limited resilience checks, but free)
- Internal architecture review processes
- Third-party resilience assessment tools

**For testing:**

- Manual game days (coordinated failure simulations)
- Deployment pipeline tests (can you rebuild from scratch?)
- Backup restoration tests (verify backups work)
- Simple scripts to simulate component failures

These alternatives require more manual effort but avoid monthly subscription costs and may be sufficient for less critical applications.

## Potential Integration Approaches

If you decide these tools are appropriate for your context, there are several ways they can be incorporated into existing processes:

### Assessment as Part of Change Control

Resilience assessments can be integrated into deployment workflows to ensure infrastructure changes maintain compliance with resilience policies. The assessment API can be called programmatically, allowing automation to verify resilience posture before releasing changes.

### Scheduled Testing Cadence

Chaos experiments can be executed on a regular schedule as part of operational practice. The cadence and impact level should match your risk tolerance and environment criticality. Consider starting with low-impact experiments in non-production environments and gradually increasing scope as confidence develops.

### Feedback Loop Pattern

Resilience Hub and FIS can work in combination: assessments identify potential weaknesses, experiments validate whether those weaknesses exist in practice, and subsequent reassessment confirms whether improvements are effective. This creates an iterative cycle of discovery, testing, and improvement.

## Summary

AWS Resilience Hub and Fault Injection Simulator are powerful tools for organisations serious about application resilience. However, they are not universal solutions.

**Use them when:**

- You have complex, stateful applications with business-critical uptime requirements
- Architectural choices materially affect your ability to meet RTO/RPO targets
- You need to validate recovery procedures with actual testing
- Compliance requires demonstrated disaster recovery capabilities

**Consider alternatives when:**

- Applications are built on fully managed, serverless services with built-in HA
- Downtime costs are minimal or non-existent
- Applications are naturally fault-tolerant by design
- Budget or complexity constraints outweigh resilience gains

The key is honest assessment of your actual resilience requirements versus the cost and complexity these tools introduce. For many applications, simpler approaches to resilience may be more appropriate.
