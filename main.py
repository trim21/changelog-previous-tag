import os
import sys

import packaging.version
import semver
from github import Github
from github import Auth

version_spec = os.environ['INPUT_VERSION-SPEC']

if version_spec == 'pep440':
    use_pep440 = True
    use_semver = False
elif version_spec == 'semver':
    use_semver = True
    use_pep440 = False
else:
    raise Exception("invalid version-spec, must be 'pep440' or 'semver'")

current_tag = os.environ['GITHUB_REF_NAME']

pre: bool

if use_pep440:
    current_version = packaging.version.Version(current_tag)
    pre = bool(current_version.is_prerelease)
else:
    current_version = semver.Version.parse(current_tag.removeprefix('v'))
    pre = bool(current_version.prerelease)

g = Github(auth=Auth.Token(os.environ['INPUT_TOKEN']))

for tag in g.get_repo(os.environ['GITHUB_REPOSITORY']).get_tags():
    if use_pep440:
        t = packaging.version.Version(tag.name)
    else:
        t = semver.Version.parse(tag.name.removeprefix('v'))

    if t >= current_version:
        continue

    if not pre:
        if use_pep440:
            if t.is_prerelease:
                continue
        else:
            if t.prerelease:
                continue

    print(f"previousTag={tag.name}")
    with open(os.environ['GITHUB_OUTPUT'], 'a') as f:
        f.write(f"\npreviousTag={tag.name}\n")

    with open(os.environ['GITHUB_ENV'], 'a') as f:
        f.write(f"\npreviousTag={tag.name}\n")

    sys.exit(0)

sys.exit(1)
