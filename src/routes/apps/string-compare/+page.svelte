<script>
	import Heading from '$lib/components/heading.svelte';
	import Paragraph from '$lib/components/paragraph.svelte';
	import CodemirrorCustom from '$lib/components/codemirror-custom.svelte';
	import { json, jsonParseLinter } from '@codemirror/lang-json';
	import { linter } from '@codemirror/lint';
	import Button from '$lib/components/button.svelte';
	import ErrorText from '$lib/components/error-text.svelte';
	import Code from '$lib/components/code.svelte';
	import CodeActions from '$lib/components/code-actions.svelte';

	const extensions = [json(), linter(jsonParseLinter())];
	let error = $state(false);
	let code = $state('');
	const prettify = () => {
		try {
			code = JSON.stringify(JSON.parse(code.trim()), null, 2);
		} catch (e) {
			error = true;
			setTimeout(() => {
				error = false;
			}, 1000);
		}
	};
	const minify = () => {
		try {
			code = JSON.stringify(JSON.parse(code.trim()));
		} catch (e) {
			error = true;
			setTimeout(() => {
				error = false;
			}, 1000);
		}
	};

	const title = `String Compare`;
	const paragraph = `Use the editor below to compare strings. This tool highlights diffs on two of your supplied texts to help you determine differences.`;
	const demoCode = ``;
</script>

<Heading level={2}>{title}</Heading>
<Paragraph>{paragraph}</Paragraph>
<br />
<Code>{demoCode}</Code>
<br />
<CodemirrorCustom bind:value={code} {extensions} />
<CodeActions>
	<Button onclick={prettify}>Prettify</Button>
	<Button onclick={minify}>Minify</Button>
	<ErrorText visible={error}>An error occurred while formatting your JSON.</ErrorText>
</CodeActions>

<style>
</style>
