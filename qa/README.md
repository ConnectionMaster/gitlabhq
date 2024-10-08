# GitLab QA - End-to-end tests for GitLab

This directory contains [end-to-end tests](../doc/development/testing_guide/end_to_end/index.md)
for GitLab. It includes the test framework and the tests themselves.

The tests can be found in `qa/specs/features` (not to be confused with the unit
tests for the test framework, which are in `spec/`).

Tests use [GitLab QA project](https://gitlab.com/gitlab-org/gitlab-qa) for environment orchestration in CI jobs.

## What is it?

GitLab QA is an end-to-end test framework designed for test GitLab.

These are black-box and entirely click-driven end-to-end tests you can run against any existing instance of GitLab.

## How does it work?

1. When we release a new version of GitLab, we build a Docker images for it.
1. Along with GitLab Docker Images we also build and publish GitLab QA images.
1. QA image can be used to execute e2e tests against running instance of GitLab.

## Validating GitLab views / partials / selectors in merge requests

We recently added a new CI job that is going to be triggered for every push
event in CE and EE projects. The job is called `qa:selectors` and it will
verify coupling between page objects implemented as a part of GitLab QA
and corresponding views / partials / selectors in CE / EE.

Whenever `qa:selectors` job fails in your merge request, you are supposed to
fix [page objects](../doc/development/testing_guide/end_to_end/page_objects.md). You should also trigger end-to-end tests
using `package-and-qa` manual action, to test if everything works fine.

## How can I use it?

You can use GitLab QA to exercise tests on any live instance! If you don't
have an instance available you can follow the instructions below to use
the [GitLab Development Kit (GDK)](https://gitlab.com/gitlab-org/gitlab-development-kit).
This is the recommended option if you would like to contribute to the tests.

Note that tests are using `Chrome` web browser by default so it should be installed and present in `PATH`.

## CI

Tests are executed in merge request pipelines as part of the development lifecycle.

- [e2e:test-on-omnibus](../doc/development/testing_guide/end_to_end/index.md#using-the-test-on-omnibus-job)
- [e2e:test-on-gdk](../doc/development/testing_guide/end_to_end/index.md#using-the-test-on-gdk-job)

### Including tests in other projects

Pipeline template for `test-on-omnibus` E2E tests is designed in a way so it can be included as a child pipeline in other projects.

Minimal configuration example would look like this:

```yaml
qa-test:
  stage: test
  variables:
    RELEASE: EE
  trigger:
    strategy: depend
    forward:
      yaml_variables: true
      pipeline_variables: true
    include:
      - project: gitlab-org/gitlab
        ref: master
        file: .gitlab/ci/test-on-omnibus/main.gitlab-ci.yml
```

To set GitLab version used for testing, following environment variables can be used:

- `RELEASE`: `omnibus` release, can be string value `EE` or `CE` for nightly release of enterprise or community edition of GitLab or can be fully qualified Docker image name
- `QA_IMAGE`: Docker image of qa code. By default inferred from `RELEASE` but can be explicitly overridden with this variable

#### Test specific environment variables

Special GitLab configurations require various specific environment variables to be present for tests to work. These can be provisioned automatically using `terraform` setup in [engineering-productivity-infrastructure](https://gitlab.com/gitlab-org/quality/engineering-productivity-infrastructure/-/tree/main/qa-resources/modules/e2e-ci) project.

### Logging

By default tests on CI use `info` log level. `debug` level is still available in case of failure debugging. Logs are stored in jobs artifacts.

### Writing tests

- [Writing tests from scratch tutorial](../doc/development/testing_guide/end_to_end/beginners_guide.md)
  - [Best practices](../doc/development/testing_guide/best_practices.md)
  - [Using page objects](../doc/development/testing_guide/end_to_end/page_objects.md)
  - [Guidelines](../doc/development/testing_guide/index.md)
  - [Tests with special setup for local environments](../doc/development/testing_guide/end_to_end/running_tests_that_require_special_setup.md)

### Run the end-to-end tests in a local development environment

First, follow the instructions to [install GDK](https://gitlab.com/gitlab-org/gitlab-development-kit/blob/main/doc/index.md) as your local GitLab development environment.

Then, navigate to the QA folder, install the gems, and run the tests via RSpec:

```bash
cd gitlab-development-kit/gitlab/qa
bundle install
bundle exec rspec <path/to/spec.rb>
```

Note:

- If you want to run tests requiring SSH against GDK, you will need to [modify your GDK setup](https://gitlab.com/gitlab-org/gitlab-qa/blob/master/docs/run_qa_against_gdk.md).
- If this is your first time running GDK, you can use the password pre-set for `root`. [See supported GitLab environment variables](https://gitlab.com/gitlab-org/gitlab-qa/-/blob/master/docs/what_tests_can_be_run.md#supported-gitlab-environment-variables). If you have changed your `root` password, export the password as `GITLAB_INITIAL_ROOT_PASSWORD`.
- By default the tests will run in a headless browser. If you'd like to watch the test execution, you can export `WEBDRIVER_HEADLESS=false`.
- Tests that are tagged `:orchestrated` require special setup (e.g., custom GitLab configuration, or additional services such as LDAP). All [orchestrated tests can be run via `gitlab-qa`](https://gitlab.com/gitlab-org/gitlab-qa/-/blob/master/docs/what_tests_can_be_run.md). There are also [setup instructions](https://docs.gitlab.com/ee/development/testing_guide/end_to_end/running_tests_that_require_special_setup.html) for running some of those tests against GDK or another local GitLab instance.

#### Remote development

For [VSCode](https://code.visualstudio.com/) user, [.devcontainer](.devcontainer/devcontainer.json) defines configuration to develop E2E tests inside a Docker container which by default is attached to the same network as environments started by [`gitlab-qa`](https://gitlab.com/gitlab-org/gitlab-qa) gem. For more information on how to use `dev containers`, see [tutorial](https://code.visualstudio.com/docs/devcontainers/tutorial).

This is useful when developing E2E tests that require GitLab instance with specific omnibus configuration. Typical workflow example:

- Start `GitLab` omnibus instance with specific configuration without running tests, for example: `gitlab-qa Test::Integration::Import EE --no-tests`. For available configurations, see [docs](https://gitlab.com/gitlab-org/gitlab-qa/-/blob/master/docs/what_tests_can_be_run.md)
- Start dev container from `VSCode` environment
- Develop and run tests from within the container which will automatically execute against started GitLab instance

#### Generic command for a typical GDK installation

The following is an example command you can use if you have configured GDK to run on a specific IP address and port, with a username, password, and personal access token that aren't the defaults, and you would like the test framework to show debug logs:

```bash
GITLAB_QA_ACCESS_TOKEN={GDK API PAT} \
GITLAB_USERNAME={GDK USERNAME} \
GITLAB_PASSWORD={GDK PASSWORD} \
QA_LOG_LEVEL=DEBUG \
QA_GITLAB_URL="http://{GDK IP ADDRESS}:{GDK PORT}" \
bundle exec rspec <path/to/spec.rb>
```

For an explanation of the variables see the [additional examples below](#overriding-gitlab-address) and the [list of supported environment variables](https://gitlab.com/gitlab-org/gitlab-qa/blob/master/docs/what_tests_can_be_run.md#supported-gitlab-environment-variables).

#### Run the end-to-end tests on GitLab in Docker

GitLab can be [installed in Docker](https://docs.gitlab.com/ee/install/docker.html).

See the section above for situations that might require adjustment to the commands below or to the configuration of the GitLab instance. [You can find more information in the documentation](https://docs.gitlab.com/ee/install/docker.html).

##### On a Unix like operating system

1.  Use the following command to start an instance that you can visit at `http://127.0.0.1`:

   ```bash
   docker run \
    --hostname 127.0.0.1 \
    --publish 80:80 --publish 22:22 \
    --name gitlab \
    --shm-size 256m \
    --env GITLAB_OMNIBUS_CONFIG="gitlab_rails['initial_root_password']='5iveL\!fe';" \
    gitlab/gitlab-ee:nightly
   ```

  Note: If you are on a Mac with [Apple Silicon](https://support.apple.com/en-us/HT211814), you will also need to add: `--platform=linux/amd64`

2. Once GitLab is up and accessible on `http://127.0.0.1`, in another shell tab, navigate to the `qa` directory of the checkout of the GitLab repository on your computer and run the following commands.

   ```bash
   bundle install
   export WEBDRIVER_HEADLESS=false
   export GITLAB_INITIAL_ROOT_PASSWORD=5iveL\!fe
   export QA_GITLAB_URL="http://127.0.0.1"
   ```

3. Most tests that do not require special setup could then be run with the following command. We will run `log_in_spec.rb` in this example.

   ```bash
   bundle exec rspec ./qa/specs/features/browser_ui/1_manage/login/log_in_spec.rb
   ```

##### On a Windows PC

1. If you don't already have these, install:
   * [Google Chrome](https://www.google.com/chrome/)
   * [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
   * [Git](https://git-scm.com/download/win)
   * [Ruby](https://rubyinstaller.org/downloads/). Please refer to the [`.ruby-version` file](../.ruby-version) for the exact version of Ruby to install.

   Note: Please be aware that [Docker Desktop must be set to use Linux containers](https://learn.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-10-linux#run-your-first-linux-container).

2. Use the following command to start an instance that you can visit at `http://127.0.0.1`. You might need to grant admin rights if asked:

   ```bash
   docker run --hostname 127.0.0.1 --publish 80:80 --publish 22:22 --name gitlab --shm-size 256m --env GITLAB_OMNIBUS_CONFIG="gitlab_rails['initial_root_password']='5iveL\!fe';" gitlab/gitlab-ee:nightly
   ```

3. Once GitLab is up and accessible on `http://127.0.0.1`, in another command prompt window, navigate to the `qa` directory of the checkout of the GitLab repository on your computer and run the following commands.

   ```bash
   bundle install
   set WEBDRIVER_HEADLESS=false
   set GITLAB_INITIAL_ROOT_PASSWORD=5iveL\!fe
   set QA_GITLAB_URL=http://127.0.0.1
   ```

4. Most tests that do not require special setup could then be run with the following command. We will run `log_in_spec.rb` in this example.

   ```bash
   bundle exec rspec .\qa\specs\features\browser_ui\1_manage\login\log_in_spec.rb
   ```

#### Running EE tests

When running EE tests you'll need to have a license available. GitLab engineers can [request a license](https://about.gitlab.com/handbook/developer-onboarding/#working-on-gitlab-ee).

Once you have the license file you can export it as an environment variable and then the framework can use it. If you do so it will be installed automatically.

```shell
export QA_EE_LICENSE=$(cat /path/to/gitlab_license)
```

#### Running specific tests

You can also supply specific tests to run as another parameter. For example, to
run the repository-related specs, you can execute:

```shell
bundle exec rspec qa/specs/features/browser_ui/3_create/repository
```

#### Running tests for transient bugs

A suite of tests have been written to test for [transient bugs](https://about.gitlab.com/handbook/engineering/quality/issue-triage/#transient-bugs).
Those tests are tagged `:transient` and therefore can be run via:

```shell
bundle exec rspec --tag transient
```

#### Overriding GitLab address

When running tests against GDK, the default address is `http://127.0.0.1:3000`. This value can be overridden by providing environment variable `QA_GITLAB_URL`:

```shell
QA_GITLAB_URL=https://gdk.test:3000 bundle exec rspec
```

#### Overriding the authenticated user

Unless told otherwise, the QA tests will run as the default `root` user seeded
by the GDK.

If you need to authenticate as a different user, you can provide the
`GITLAB_USERNAME` and `GITLAB_PASSWORD` environment variables:

```shell
GITLAB_USERNAME=jsmith GITLAB_PASSWORD=password bundle exec rspec
```

Some QA tests require logging in as an admin user. By default, the QA
tests will use the same `root` user seeded by the GDK.

If you need to authenticate with different admin credentials, you can
provide the `GITLAB_ADMIN_USERNAME` and `GITLAB_ADMIN_PASSWORD`
environment variables:

```shell
GITLAB_ADMIN_USERNAME=admin GITLAB_ADMIN_PASSWORD=myadminpassword GITLAB_USERNAME=jsmith GITLAB_PASSWORD=password bundle exec rspec
```

If your user doesn't have permission to default sandbox group
`gitlab-qa-sandbox`, you could also use another sandbox group by giving
`GITLAB_SANDBOX_NAME`:

```shell
GITLAB_USERNAME=jsmith GITLAB_PASSWORD=password GITLAB_SANDBOX_NAME=jsmith-qa-sandbox bundle exec rspec
```

All [supported environment variables are here](https://gitlab.com/gitlab-org/gitlab-qa/blob/master/docs/what_tests_can_be_run.md#supported-environment-variables).

#### Sending additional cookies

The environment variable `QA_COOKIES` can be set to send additional cookies
on every request. This is necessary on `gitlab.com` to direct traffic to the
canary fleet. To do this set `QA_COOKIES="gitlab_canary=true"`.

To set multiple cookies, separate them with the `;` character, for example: `QA_COOKIES="cookie1=value;cookie2=value2"`

#### Headless browser

By default tests use headless browser. To override that, `WEBDRIVER_HEADLESS` must be set to `false`:

```shell
WEBDRIVER_HEADLESS=false bundle exec rspec
```

#### Log level

By default, the tests use the `info` log level. To change the test's log level, the environment variable `QA_LOG_LEVEL` can be set:

```shell
QA_LOG_LEVEL=debug bundle exec rspec
```

### Building a Docker image to test

Once you have made changes to the CE/EE repositories, you may want to build a
Docker image to test locally instead of waiting for the `gitlab-ce-qa` or
`gitlab-ee-qa` nightly builds. To do that, you can run **from the top `gitlab`
directory** (one level up from this directory):

```sh
docker build -t gitlab/gitlab-ce-qa:nightly --file ./qa/Dockerfile ./
```

### Quarantined tests

Tests can be put in quarantine by assigning `:quarantine` metadata. This means
they will be skipped unless run with `--tag quarantine`. This can be used for
tests that are expected to fail while a fix is in progress (similar to how
[`skip` or `pending`](https://relishapp.com/rspec/rspec-core/v/3-8/docs/pending-and-skipped-examples)
 can be used).

```shell
bundle exec rspec --tag quarantine
```

### Running tests with a custom bin/qa test runner

`bin/qa` is an additional custom wrapper script that abstracts away some of the more complicated setups that some tests require. This option requires test scenario and test instance's GitLab address to be specified in the command. For example, to run any `Instance` scenario test, the following command can be used:

```shell
bundle exec bin/qa Test::Instance::All http://localhost:3000
```

#### Running tests with a feature flag enabled or disabled

Tests can be run with a feature flag enabled or disabled by using the command-line
option `--enable-feature FEATURE_FLAG` or `--disable-feature FEATURE_FLAG`.

For example, to enable the feature flag that enforces Gitaly request limits,
you would use the command:

```shell
bundle exec bin/qa Test::Instance::All http://localhost:3000 --enable-feature gitaly_enforce_requests_limits
```

This will instruct the QA framework to enable the `gitaly_enforce_requests_limits`
feature flag ([via the API](https://docs.gitlab.com/ee/api/features.html)), run
all the tests in the `Test::Instance::All` scenario, and then disable the
feature flag again.

Similarly, to disable the feature flag that enforces Gitaly request limits,
you would use the command:

```shell
bundle exec bin/qa Test::Instance::All http://localhost:3000 --disable-feature gitaly_enforce_requests_limits
```

This will instruct the QA framework to disable the `gitaly_enforce_requests_limits`
feature flag ([via the API](https://docs.gitlab.com/ee/api/features.html)) if not already disabled,
run all the tests in the `Test::Instance::All` scenario, and then enable the
feature flag again if it was enabled earlier.

Note: You can also [toggle feature
flags in the tests themselves](https://docs.gitlab.com/ee/development/testing_guide/end_to_end/feature_flags.html).

Note also that the `--` separator isn't used because `--enable-feature` and `--disable-feature`
are QA framework options, not `rspec` options.
