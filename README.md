<!-- jr-brand:start -->
<div align="center">
  <a href="https://jannikreinhard.com/">
    <img src="https://raw.githubusercontent.com/JayRHa/.github/main/assets/readme/collection.svg" alt="Jannik Reinhard — AI, Cloud and Endpoint Management" width="100%">
  </a>
  <h1>Endpoint Analytics Remediation Scripts</h1>
  <p><strong>Ready-to-use Microsoft Intune Endpoint Analytics Proactive Remediation detection and remediation scripts.</strong></p>
  <p>
  <a href="https://jannikreinhard.com/"><img src="https://img.shields.io/badge/Website-0A5FC0?style=flat-square&amp;logo=wordpress&amp;logoColor=white" alt="Website"></a>
  <a href="https://github.com/JayRHa"><img src="https://img.shields.io/badge/GitHub-081427?style=flat-square&amp;logo=github&amp;logoColor=white" alt="GitHub"></a>
  <a href="https://www.linkedin.com/in/jannik-r/"><img src="https://img.shields.io/badge/LinkedIn-0795FF?style=flat-square&amp;logo=linkedin&amp;logoColor=white" alt="LinkedIn"></a>
  <a href="https://x.com/jannik_reinhard"><img src="https://img.shields.io/badge/X-081427?style=flat-square&amp;logo=x&amp;logoColor=white" alt="X"></a>
  <a href="https://www.youtube.com/@ModernDevMgmt/featured"><img src="https://img.shields.io/badge/YouTube-0A5FC0?style=flat-square&amp;logo=youtube&amp;logoColor=white" alt="YouTube"></a>
</p>
  <p><sub>Open-Source Collection · PowerShell · Practical by design</sub></p>
</div>
<!-- jr-brand:end -->

**The largest community-driven collection of Intune Endpoint Analytics remediation scripts.**

Detect. Remediate. Automate.

## Overview

This repository provides a growing library of **production-ready** detection and remediation scripts for [Microsoft Intune Endpoint Analytics](https://learn.microsoft.com/en-us/mem/analytics/proactive-remediations). Each script package includes a detection script and (where applicable) a remediation script that you can deploy directly to your environment.

> **Browse the folders above** to explore all available scripts -- from security hardening and Defender configuration to disk cleanup, Teams management, and more.

<!-- project-context:start -->
## Project Context

Endpoint Analytics Remediation Scripts is a deployable script library for Intune administrators who want ready-to-use detection and remediation packages. The repository is organized around script folders, where each package can be reviewed, tested, and then deployed through Microsoft Intune proactive remediations.

- Use it when endpoint issues should be detected automatically and remediated consistently.
- Each script package is designed to separate detection from remediation so administrators can validate behavior before rollout.
- The repository acts as both a community script catalog and a practical deployment reference.

## How It Works

Administrators pick a script package, review the detection and remediation logic, upload it to Intune, and assign it to the intended device scope. Endpoints run detection first; remediation runs only when the detection result indicates that action is needed.

```mermaid
flowchart LR
    Library[Script package library] --> Review[Review detection and remediation]
    Review --> Intune[Upload to Microsoft Intune]
    Intune --> Assignment[Assign to device scope]
    Assignment --> Detection[Run detection script]
    Detection --> Decision{Issue detected?}
    Decision -- No --> Report[Report compliant result]
    Decision -- Yes --> Remediation[Run remediation script]
    Remediation --> Verify[Verify endpoint state]
    Verify --> Report
```

<!-- project-context:end -->

## Quickstart

### Deploy a script package in Intune

1. Open the [**Intune Portal**](https://intune.microsoft.com/) and navigate to **Devices** > **Scripts and remediations**

2. Click **+ Create**

   ![Create script package](https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/blob/main/assets/1.png)

3. Enter a **Name**, **Description**, **Publisher**, and **Version**, then click **Next**

   ![Enter details](https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/blob/main/assets/2.png)

4. Upload the **Detection script** (and optionally the **Remediation script**), then click **Next**

   ![Upload scripts](https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/blob/main/assets/3.webp)

5. Configure **Scope tags** and **Assignments**, then click **Review + create**

   ![Assign and create](https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/blob/main/assets/4.webp)

## Contributing

We love contributions from the Intune community! Here's how you can help:

| | How to contribute |
|---|---|
| **Got an idea?** | [Open an issue](https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/issues/new) describing the script you'd like to see |
| **Got a script?** | Use the template in [`0 - Template`](./0%20-%20Template) and submit a pull request |

![Submit an idea](https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/blob/main/assets/submitIdea.png)

## Contributors

Thanks to everyone who has contributed to this project!

<a href="https://github.com/JayRHa/EndpointAnalyticsRemediationScripts/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=JayRHa/EndpointAnalyticsRemediationScripts" />
</a>

### Disclaimer

*This is a community repository. There is no guarantee for the scripts provided here.*
*Please review and test thoroughly before deploying to production environments.*

<br>

**If this repo helps you, consider giving it a :star:**

## License

This project is available under the terms in [LICENSE](LICENSE).

<!-- jr-brand-footer:start -->

---

<div align="center">
  <p><sub>Built and maintained by <a href="https://jannikreinhard.com/">Jannik Reinhard</a> · Microsoft MVP for Security and AI Platform.</sub></p>
  <p><a href="https://www.buymeacoffee.com/jannikreinf">Support the open-source work</a></p>
  <p><strong>Stay healthy, Cheers Jannik</strong></p>
</div>

<!-- jr-brand-footer:end -->
