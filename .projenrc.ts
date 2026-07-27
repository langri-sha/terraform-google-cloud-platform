import { Project } from '@langri-sha/projen-project'
import { YamlFile } from 'projen'

const project = new Project({
  name: 'terraform-google-cloud-platform',
  package: {
    authorEmail: 'filip.dupanovic@gmail.com',
    authorName: 'Filip Dupanović',
    authorOrganization: false,
    authorUrl: 'https://langri-sha.com',
    bugsUrl:
      'https://github.com/langri-sha/terraform-google-cloud-platform/issues',
    homepage:
      'https://github.com/langri-sha/terraform-google-cloud-platform/#readme',
    minNodeVersion: '24.16.0',
    repository: 'langri-sha/terraform-google-cloud-platform',
    type: 'module',

    entrypoint: '',
    npmProvenance: false,

    copyrightYear: '2022',
    license: 'MIT',
    licensed: true,

    devDeps: [
      '@langri-sha/prettier@^0.4.2',
      'prettier-plugin-ini@^1.3.0',
      'prettier@3.9.6',
    ],
    peerDependencyOptions: {
      pinnedDevDependency: false,
    },
  },
  codeowners: {
    '*': '@langri-sha',
  },
  editorConfig: {},
  lintSynthesized: {},
  prettier: {},
  renovate: {
    packageRules: [
      {
        description: 'Packages published from the langri-sha/projen monorepo',
        groupName: 'langri-sha projen toolchain',
        groupSlug: 'langri-sha-projen',
        matchSourceUrls: ['https://github.com/langri-sha/projen'],
      },
    ],
    customManagers: [
      {
        customType: 'regex',
        datasourceTemplate: 'github-releases',
        depNameTemplate: 'hashicorp/terraform',
        extractVersionTemplate: '^v(?<version>.+)$',
        managerFilePatterns: ['/^\\.github/workflows/terraform\\.yml$/'],
        matchStrings: ['TERRAFORM_VERSION:\\s*(?<currentValue>\\S+)'],
      },
    ],
  },
  typeScriptConfig: {},
  withTerraform: true,

  gitIgnoreOptions: {
    ignorePatterns: ['.terraform.lock.hcl'],
  },
})

project.package?.addEngine('pnpm', '>= 11.0.0')
project.package?.addField('packageManager', 'pnpm@11.17.0')
project.package?.addField('private', true)

project.tryFindObjectFile('package.json')?.addDeletionOverride('pnpm')

new YamlFile(project, 'pnpm-workspace.yaml', {
  readonly: true,
  marker: true,
  obj: {
    allowBuilds: {
      '@swc/core': false,
      esbuild: false,
    },
    minimumReleaseAgeExclude: [
      '@langri-sha/projen-babel@0.5.3',
      '@langri-sha/projen-beachball@0.5.5',
      '@langri-sha/projen-codeowners@0.5.5',
      '@langri-sha/projen-editorconfig@0.6.5',
      '@langri-sha/projen-eslint@0.3.6',
      '@langri-sha/projen-husky@0.3.13',
      '@langri-sha/projen-jest-config@0.4.6',
      '@langri-sha/projen-license@0.3.8',
      '@langri-sha/projen-lint-staged@0.3.7',
      '@langri-sha/projen-lint-synthesized@0.5.7',
      '@langri-sha/projen-pnpm-workspace@0.3.6',
      '@langri-sha/projen-prettier@0.4.6',
      '@langri-sha/projen-project@0.21.0',
      '@langri-sha/projen-readme@0.1.5',
      '@langri-sha/projen-renovate@0.4.10',
      '@langri-sha/projen-swcrc@0.1.10',
      '@langri-sha/projen-typescript-config@0.5.11',
      '@langri-sha/tsconfig@1.0.0',
    ],
  },
})

project.synth()
