# Guidance on how to contribute

There are two primary ways to help:
* using the issue tracker, and
* changing the code-base.

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
