<script>
	import Heading from '$lib/components/heading.svelte';
	import Paragraph from '$lib/components/paragraph.svelte';
	import CodemirrorCustom from '$lib/components/codemirror-custom.svelte';
	import Button from '$lib/components/button.svelte';
	import ErrorText from '$lib/components/error-text.svelte';
	import Code from '$lib/components/code.svelte';
	import CodeActions from '$lib/components/code-actions.svelte';
	import DiffView from '$lib/components/diff-view.svelte';

	let error = $state(false);
	let string1 = $state('');
	let string2 = $state('');
	let finalString1 = $state('');
	let finalString2 = $state('');
	let diffIndices = $state([]);

	const compare = () => {
		diffIndices = [];
		const maxLength = Math.max(string1.length, string2.length);

		for (let i = 0; i < maxLength; i++) {
			if (string1[i] !== string2[i]) {
				diffIndices.push(i);
			}
		}

		finalString1 = string1;
		finalString2 = string2;
	};

	const title = `String Compare`;
	const paragraph = `Use the editor below to compare strings. This tool highlights diffs on two of your supplied texts to help you determine differences.`;
	const demoCode = `const compare = (string1, string2) => {
	const maxLength = Math.max(string1.length, string2.length);

	for (let i = 0; i < maxLength; i++) {
		if (string1[i] !== string2[i]) {
			diffIndices.push(i);
		}
	}

	return diffIndices;
}`;
</script>

<Heading level={2}>{title}</Heading>
<Paragraph>{paragraph}</Paragraph>
<br />
<Code>{demoCode}</Code>
<br />
<CodeActions>
	<Button onclick={compare}>Compare</Button>
	<ErrorText visible={error}>An error occurred while formatting your JSON.</ErrorText>
</CodeActions>
<div class="split-view">
	<div class="view">
		<CodemirrorCustom bind:value={string1} />
		<DiffView text={finalString1} diffs={diffIndices} />
	</div>
	<div class="view">
		<CodemirrorCustom bind:value={string2} />
		<DiffView text={finalString2} diffs={diffIndices} />
	</div>
</div>

<style>
	.split-view {
		display: grid;
		grid-template-columns: 1fr 1fr;
	}
</style>
