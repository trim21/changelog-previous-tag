import * as core from '@actions/core';
import * as github from '@actions/github';
import * as semver from 'semver';
import * as pep440 from '@renovatebot/pep440';

function removePrefix(str: string, prefix: string): string {
  return str.startsWith(prefix) ? str.slice(prefix.length) : str;
}

async function main(): Promise<void> {
  const versionSpec = core.getInput('version-spec') || 'semver';
  const token = core.getInput('token') || process.env.GITHUB_TOKEN || '';
  if (!token) {
    core.setFailed('token input or GITHUB_TOKEN is required');
    return;
  }

  if (versionSpec !== 'pep440' && versionSpec !== 'semver') {
    core.setFailed("invalid version-spec, must be 'pep440' or 'semver'");
    return;
  }

  const usePep440 = versionSpec === 'pep440';
  const currentTag = removePrefix(github.context.ref, 'refs/tags/');

  if (!currentTag) {
    core.setFailed('Could not determine current tag from GITHUB_REF');
    return;
  }

  let isPre: boolean;

  if (usePep440) {
    if (!pep440.valid(currentTag)) {
      core.setFailed(`Invalid pep440 version: ${currentTag}`);
      return;
    }
    isPre = pep440.parse(currentTag)?.is_prerelease ?? false;
  } else {
    const parsed = semver.parse(currentTag.replace(/^v/, ''));
    if (!parsed) {
      core.setFailed(`Invalid semver tag: ${currentTag}`);
      return;
    }
    isPre = parsed.prerelease.length > 0;
  }

  if (isPre) {
    core.exportVariable('preRelease', 'true');
    core.setOutput('preRelease', 'true');
  }

  const octokit = github.getOctokit(token);
  const { owner, repo } = github.context.repo;

  let currentSemver: semver.SemVer | null = null;
  if (!usePep440) {
    currentSemver = semver.parse(currentTag.replace(/^v/, ''));
  }

  for await (const { data: tags } of octokit.paginate.iterator(octokit.rest.repos.listTags, {
    owner,
    repo,
    per_page: 100,
  })) {
    for (const tag of tags) {
      if (usePep440) {
        if (!pep440.valid(tag.name)) continue;
        if (pep440.gte(tag.name, currentTag)) continue;
        if (!isPre && (pep440.parse(tag.name)?.is_prerelease ?? false)) continue;
      } else {
        const tagVersion = semver.parse(tag.name.replace(/^v/, ''));
        if (!tagVersion) continue;
        if (semver.gte(tagVersion, currentSemver!)) continue;
        if (!isPre && tagVersion.prerelease.length > 0) continue;
      }

      core.info(`previousTag=${tag.name}`);
      core.setOutput('previousTag', tag.name);
      core.exportVariable('previousTag', tag.name);
      return;
    }
  }

  core.setFailed('No previous tag found');
}

main().catch((err: Error) => {
  core.setFailed(err.message || String(err));
  process.exit(1);
});
