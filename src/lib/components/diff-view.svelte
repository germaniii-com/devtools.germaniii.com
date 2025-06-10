<script>
	import Paragraph from './paragraph.svelte';

	let { text, diffs = [] } = $props();
	let chars = $derived(text.split(''));

	const isDiff = (charIdx) => diffs.some((idx) => parseInt(charIdx) === parseInt(idx));
</script>

{#if chars.length <= 0}
	<span></span>
{:else if chars.length > 0}
	<Paragraph>Length : {text.length}</Paragraph>
	<p>
		{#each chars as char, charIdx ((char, charIdx))}
			{#if isDiff(charIdx)}
				<span class="diff">{char}</span>
			{:else}
				<span class="normal">{char}</span>
			{/if}
		{/each}
	</p>
{:else}
	<Paragraph>There are no diffs between your texts.</Paragraph>
{/if}

<style>
	span {
		font-family: Noto Sans;
		font-size: 1em;
		letter-spacing: 5px;
		padding: 1px;
	}

	.diff {
		background-color: var(--blue-dim);
		color: var(--blue);
	}
	.normal {
		background-color: var(--gray-dim);
		color: var(--fg);
	}
</style>
