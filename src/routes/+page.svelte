<script>
	import Code from "$lib/components/code.svelte";
import Heading from "$lib/components/heading.svelte";
	import Paragraph from "$lib/components/paragraph.svelte";

</script>

<Heading level={2}>Welcome to SvelteKit</Heading>
<Paragraph>
	Welcome to SvelteKit this is a section of description, we will be putting explanations on this font
</Paragraph>
<Code>
{
`public static void main(String args[]) {
		String test = "";
}`
}
</Code>
