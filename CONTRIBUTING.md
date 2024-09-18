# Guidance on how to contribute

There are two primary ways to help:
* using the issue tracker, and
* changing the code-base.

## General Remarks

You are welcome to contribute content (code, documentation etc.) to this open source project.

There are some important things to know:

1. You must **comply to the license of this project**, **accept the Developer Certificate of Origin** (see below) before being able to contribute. The acknowledgement to the DCO will usually be requested from you as part of your first pull request to this project.
2. Please **adhere to our [Code of Conduct](CODE_OF_CONDUCT.md)**.
3. If you plan to use **generative AI for your contribution**, please see our guideline below.
4. **Not all proposed contributions can be accepted**. Some features may fit another project better or doesn't fit the general direction of this project. Of course, this doesn't apply to most bug fixes, but a major feature implementation for instance needs to be discussed with one of the maintainers first. Possibly, one who touched the related code or module recently. The more effort you invest, the better you should clarify in advance whether the contribution will match the project's direction. The best way would be to just open an issue to discuss the feature you plan to implement (make it clear that you intend to contribute). We will then forward the proposal to the respective code owner. This avoids disappointment.

## Developer Certificate of Origin (DCO)

Contributors will be asked to accept a DCO before they submit the first pull request to this projects, this happens in an automated fashion during the submission process. SAP uses [the standard DCO text of the Linux Foundation](https://developercertificate.org/).

## Contributing with AI-generated code

As artificial intelligence evolves, AI-generated code is becoming valuable for many software projects, including open-source initiatives. While we recognize the potential benefits of incorporating AI-generated content into our open-source projects there a certain requirements that need to be reflected and adhered to when making contributions.

Please see our [guideline for AI-generated code contributions to SAP Open Source Software Projects](CONTRIBUTING_USING_GENAI.md) for these requirements.

## How to Contribute

1. Make sure the change is welcome (see [General Remarks](#general-remarks)).
2. Create a branch by forking the repository and apply your change.
3. Commit and push your change on that branch.
4. Create a pull request in the repository using this branch.
5. Follow the link posted by the CLA assistant to your pull request and accept it, as described above.
6. Wait for our code review and approval, possibly enhancing your change on request.
    - Note that the maintainers have many duties. So, depending on the required effort for reviewing, testing, and clarification, this may take a while.
7. Once the change has been approved and merged, we will inform you in a comment.
8. Celebrate!

## Using the issue tracker

Use the issue tracker to suggest feature requests, report bugs, and ask
questions. This is also a great way to connect with the developers of the
project as well as others who are interested in this solution.

Use the issue tracker to find ways to contribute. Find a bug or a feature,
mention in the issue that you will take on that effort, then follow the
guidance below.

## Changing the code-base

Generally speaking, you should fork this repository, make changes in your own
fork, and then submit a pull-request. All new code should have been thoroughly
tested end-to-end in order to validate implemented features and the presence or
lack of defects. All new scripts and docker files _must_ come with automated (unit)
tests.

The contract of functionality exposed by docker files functionality needs
to be documented, so it can be properly used. Implementation of a functionality
and its documentation shall happen within the same commit(s).

#### Consistent USER Instruction in the Dockerfile

Set the user name (or UID) and the user group (or GID) to UID 1000 and GID 1000 to be consistent ith the Jenkins image.

````
USER 1000:1000
````
