import os
import sys

import packaging.version
import semver
from github import Github
from github import Auth

version_spec = os.environ['INPUT_VERSION_SPEC']

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
    pre = bool(packaging.version.Version(current_tag).is_prerelease)
else:
    pre = bool(semver.Version.parse(current_tag).prerelease)

g = Github(auth=Auth.Token(os.environ['INPUT_TOKEN']))

for tag in g.get_repo(os.environ['GITHUB_REPOSITORY']).get_tags():
    if tag.name == current_tag:
        continue

    if not pre:
        if use_pep440:
            if packaging.version.Version(tag.name).is_prerelease:
                continue
        else:
            if semver.Version.parse(tag.name).prerelease:
                continue

    print(f"previousTag={tag.name}")
    with open(os.environ['GITHUB_OUTPUT'], 'a') as f:
        f.write(f"\npreviousTag={tag.name}\n")

    sys.exit(0)

sys.exit(1)
