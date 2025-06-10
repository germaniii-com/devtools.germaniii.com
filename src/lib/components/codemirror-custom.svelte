<script>
	import { birdsOfParadise } from 'thememirror';
	import CodeMirror from 'svelte-codemirror-editor';
	import { json } from '@codemirror/lang-json';

	let {
		value = $bindable('\n\n\n\n\n\n\n\n\n\n\n\n\n\n'),
		lang = json(),
		editable = true,
		extensions = []
	} = $props();
</script>

<div class="code">
	<CodeMirror bind:value {lang} {editable} extensions={[birdsOfParadise, ...extensions]} />
</div>

<style>
	.code {
		overflow: auto;
		max-height: 50vh;
		margin: 0.5em;
		padding: 0.5em;
		border: 1px solid var(--blue-dim);
		border-radius: 5px;
	}
</style>
