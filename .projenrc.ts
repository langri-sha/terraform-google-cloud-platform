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

    licensed: false,

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
  },
})

project.synth()
