<script>
	let inputText = $state('#ff6347');

	const namedColors = {
		aliceblue: [240, 248, 255],
		antiquewhite: [250, 235, 215],
		aqua: [0, 255, 255],
		aquamarine: [127, 255, 212],
		azure: [240, 255, 255],
		beige: [245, 245, 220],
		bisque: [255, 228, 196],
		black: [0, 0, 0],
		blanchedalmond: [255, 235, 205],
		blue: [0, 0, 255],
		blueviolet: [138, 43, 226],
		brown: [165, 42, 42],
		burlywood: [222, 184, 135],
		cadetblue: [95, 158, 160],
		chartreuse: [127, 255, 0],
		chocolate: [210, 105, 30],
		coral: [255, 127, 80],
		cornflowerblue: [100, 149, 237],
		cornsilk: [255, 248, 220],
		crimson: [220, 20, 60],
		cyan: [0, 255, 255],
		darkblue: [0, 0, 139],
		darkcyan: [0, 139, 139],
		darkgoldenrod: [184, 134, 11],
		darkgray: [169, 169, 169],
		darkgreen: [0, 100, 0],
		darkgrey: [169, 169, 169],
		darkkhaki: [189, 183, 107],
		darkmagenta: [139, 0, 139],
		darkolivegreen: [85, 107, 47],
		darkorange: [255, 140, 0],
		darkorchid: [153, 50, 204],
		darkred: [139, 0, 0],
		darksalmon: [233, 150, 122],
		darkseagreen: [143, 188, 143],
		darkslateblue: [72, 61, 139],
		darkslategray: [47, 79, 79],
		darkslategrey: [47, 79, 79],
		darkturquoise: [0, 206, 209],
		darkviolet: [148, 0, 211],
		deeppink: [255, 20, 147],
		deepskyblue: [0, 191, 255],
		dimgray: [105, 105, 105],
		dimgrey: [105, 105, 105],
		dodgerblue: [30, 144, 255],
		firebrick: [178, 34, 34],
		floralwhite: [255, 250, 240],
		forestgreen: [34, 139, 34],
		fuchsia: [255, 0, 255],
		gainsboro: [220, 220, 220],
		ghostwhite: [248, 248, 255],
		gold: [255, 215, 0],
		goldenrod: [218, 165, 32],
		gray: [128, 128, 128],
		green: [0, 128, 0],
		greenyellow: [173, 255, 47],
		grey: [128, 128, 128],
		honeydew: [240, 255, 240],
		hotpink: [255, 105, 180],
		indianred: [205, 92, 92],
		indigo: [75, 0, 130],
		ivory: [255, 255, 240],
		khaki: [240, 230, 140],
		lavender: [230, 230, 250],
		lavenderblush: [255, 240, 245],
		lawngreen: [124, 252, 0],
		lemonchiffon: [255, 250, 205],
		lightblue: [173, 216, 230],
		lightcoral: [240, 128, 128],
		lightcyan: [224, 255, 255],
		lightgoldenrodyellow: [250, 250, 210],
		lightgray: [211, 211, 211],
		lightgreen: [144, 238, 144],
		lightgrey: [211, 211, 211],
		lightpink: [255, 182, 193],
		lightsalmon: [255, 160, 122],
		lightseagreen: [32, 178, 170],
		lightskyblue: [135, 206, 250],
		lightslategray: [119, 136, 153],
		lightslategrey: [119, 136, 153],
		lightsteelblue: [176, 196, 222],
		lightyellow: [255, 255, 224],
		lime: [0, 255, 0],
		limegreen: [50, 205, 50],
		linen: [250, 240, 230],
		magenta: [255, 0, 255],
		maroon: [128, 0, 0],
		mediumaquamarine: [102, 205, 170],
		mediumblue: [0, 0, 205],
		mediumorchid: [186, 85, 211],
		mediumpurple: [147, 112, 219],
		mediumseagreen: [60, 179, 113],
		mediumslateblue: [123, 104, 238],
		mediumspringgreen: [0, 250, 154],
		mediumturquoise: [72, 209, 204],
		mediumvioletred: [199, 21, 133],
		midnightblue: [25, 25, 112],
		mintcream: [245, 255, 250],
		mistyrose: [255, 228, 225],
		moccasin: [255, 228, 181],
		navajowhite: [255, 222, 173],
		navy: [0, 0, 128],
		oldlace: [253, 245, 230],
		olive: [128, 128, 0],
		olivedrab: [107, 142, 35],
		orange: [255, 165, 0],
		orangered: [255, 69, 0],
		orchid: [218, 112, 214],
		palegoldenrod: [238, 232, 170],
		palegreen: [152, 251, 152],
		paleturquoise: [175, 238, 238],
		palevioletred: [219, 112, 147],
		papayawhip: [255, 239, 213],
		peachpuff: [255, 218, 185],
		peru: [205, 133, 63],
		pink: [255, 192, 203],
		plum: [221, 160, 221],
		powderblue: [176, 224, 230],
		purple: [128, 0, 128],
		rebeccapurple: [102, 51, 153],
		red: [255, 0, 0],
		rosybrown: [188, 143, 143],
		royalblue: [65, 105, 225],
		saddlebrown: [139, 69, 19],
		salmon: [250, 128, 114],
		sandybrown: [244, 164, 96],
		seagreen: [46, 139, 87],
		seashell: [255, 245, 238],
		sienna: [160, 82, 45],
		silver: [192, 192, 192],
		skyblue: [135, 206, 235],
		slateblue: [106, 90, 205],
		slategray: [112, 128, 144],
		slategrey: [112, 128, 144],
		snow: [255, 250, 250],
		springgreen: [0, 255, 127],
		steelblue: [70, 130, 180],
		tan: [210, 180, 140],
		teal: [0, 128, 128],
		thistle: [216, 191, 216],
		tomato: [255, 99, 71],
		turquoise: [64, 224, 208],
		violet: [238, 130, 238],
		wheat: [245, 222, 179],
		white: [255, 255, 255],
		whitesmoke: [245, 245, 245],
		yellow: [255, 255, 0],
		yellowgreen: [154, 205, 50]
	};

	function parseColor(str) {
		const s = str.trim();
		if (!s) return null;

		let m = s.match(/^#?([a-f\d]{3,8})$/i);
		if (m) return parseHex(m[1]);

		m = s.match(/^rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(?:,\s*([\d.]+%?)\s*)?\)$/i);
		if (m) {
			let a = m[4] !== undefined ? parseFloat(m[4]) : 1;
			if (m[4] && m[4].includes('%')) a = parseFloat(m[4]) / 100;
			return {
				r: clamp(+m[1], 0, 255),
				g: clamp(+m[2], 0, 255),
				b: clamp(+m[3], 0, 255),
				a: clamp(a, 0, 1)
			};
		}

		m = s.match(/^hsla?\(\s*(\d+)\s*,\s*(\d+)%\s*,\s*(\d+)%\s*(?:,\s*([\d.]+%?)\s*)?\)$/i);
		if (m) {
			let a = m[4] !== undefined ? parseFloat(m[4]) : 1;
			if (m[4] && m[4].includes('%')) a = parseFloat(m[4]) / 100;
			const rgb = hslToRgb(+m[1], clamp(+m[2], 0, 100), clamp(+m[3], 0, 100));
			return { r: rgb.r, g: rgb.g, b: rgb.b, a: clamp(a, 0, 1) };
		}

		const named = namedColors[s.toLowerCase()];
		if (named) return { r: named[0], g: named[1], b: named[2], a: 1 };

		return null;
	}

	function parseHex(h) {
		let r,
			g,
			b,
			a = 1;
		if (h.length === 3) {
			r = parseInt(h[0] + h[0], 16);
			g = parseInt(h[1] + h[1], 16);
			b = parseInt(h[2] + h[2], 16);
		} else if (h.length === 4) {
			r = parseInt(h[0] + h[0], 16);
			g = parseInt(h[1] + h[1], 16);
			b = parseInt(h[2] + h[2], 16);
			a = parseInt(h[3] + h[3], 16) / 255;
		} else if (h.length === 6) {
			r = parseInt(h.slice(0, 2), 16);
			g = parseInt(h.slice(2, 4), 16);
			b = parseInt(h.slice(4, 6), 16);
		} else if (h.length === 8) {
			r = parseInt(h.slice(0, 2), 16);
			g = parseInt(h.slice(2, 4), 16);
			b = parseInt(h.slice(4, 6), 16);
			a = parseInt(h.slice(6, 8), 16) / 255;
		} else {
			return null;
		}
		if (isNaN(r) || isNaN(g) || isNaN(b)) return null;
		return { r: clamp(r, 0, 255), g: clamp(g, 0, 255), b: clamp(b, 0, 255), a: clamp(a, 0, 1) };
	}

	function hslToRgb(h, s, l) {
		h /= 360;
		s /= 100;
		l /= 100;
		const a = s * Math.min(l, 1 - l);
		const f = (n) => {
			const k = (n + h * 12) % 12;
			return l - a * Math.max(-1, Math.min(k - 3, 9 - k, 1));
		};
		return { r: Math.round(f(0) * 255), g: Math.round(f(8) * 255), b: Math.round(f(4) * 255) };
	}

	function rgbToHsl(r, g, b) {
		r /= 255;
		g /= 255;
		b /= 255;
		const max = Math.max(r, g, b);
		const min = Math.min(r, g, b);
		let h = 0,
			s = 0,
			l = (max + min) / 2;
		if (max !== min) {
			const d = max - min;
			s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
			switch (max) {
				case r:
					h = ((g - b) / d + (g < b ? 6 : 0)) / 6;
					break;
				case g:
					h = ((b - r) / d + 2) / 6;
					break;
				case b:
					h = ((r - g) / d + 4) / 6;
					break;
			}
		}
		return { h: Math.round(h * 360), s: Math.round(s * 100), l: Math.round(l * 100) };
	}

	function clamp(v, min, max) {
		return Math.max(min, Math.min(max, v));
	}

	function toHex(r, g, b) {
		return '#' + [r, g, b].map((v) => v.toString(16).padStart(2, '0')).join('');
	}

	function toHex8(r, g, b, a) {
		return (
			'#' + [r, g, b, Math.round(a * 255)].map((v) => v.toString(16).padStart(2, '0')).join('')
		);
	}

	let parsedColor = $derived.by(() => {
		if (!inputText.trim()) return null;
		return parseColor(inputText);
	});

	let error = $derived.by(() => {
		if (!inputText.trim()) return '';
		if (!parsedColor)
			return 'Invalid color value. Try hex (#ff0000), rgb(), hsl(), or a named color.';
		return '';
	});

	let pickerHex = $derived.by(() => {
		if (!parsedColor) return '#000000';
		return toHex(parsedColor.r, parsedColor.g, parsedColor.b);
	});

	let cssColor = $derived.by(() => {
		if (!parsedColor) return 'transparent';
		return `rgba(${parsedColor.r}, ${parsedColor.g}, ${parsedColor.b}, ${parsedColor.a})`;
	});

	let stats = $derived.by(() => {
		if (!parsedColor) return [];
		const { r, g, b, a } = parsedColor;
		const hsl = rgbToHsl(r, g, b);
		return [
			{ label: 'HEX', value: toHex(r, g, b), css: 'blue' },
			{ label: 'HEX (8-digit)', value: toHex8(r, g, b, a), css: 'cyan' },
			{ label: 'RGB', value: `rgb(${r}, ${g}, ${b})`, css: 'green' },
			{ label: 'RGBA', value: `rgba(${r}, ${g}, ${b}, ${a})`, css: 'emerald' },
			{ label: 'HSL', value: `hsl(${hsl.h}, ${hsl.s}%, ${hsl.l}%)`, css: 'orange' },
			{ label: 'HSLA', value: `hsla(${hsl.h}, ${hsl.s}%, ${hsl.l}%, ${a})`, css: 'purple' }
		];
	});

	function handleColorPick(e) {
		inputText = e.target.value;
	}
</script>

<div class="color-converter-container">
	<div class="tool-header">
		<h1>Color Converter</h1>
		<p class="tool-description">
			Pick a color visually or type any format — HEX, RGB, HSL, or named colors.
		</p>
	</div>

	<div class="picker-area animate-fade-in">
		<div class="color-picker-wrapper">
			<input
				type="color"
				id="color-picker"
				value={pickerHex}
				onchange={handleColorPick}
				style="background-color: {pickerHex}"
			/>
			<input
				type="text"
				id="color-text-input"
				bind:value={inputText}
				placeholder="#ff0000, rgb(255,0,0), hsl(0,100%,50%), red..."
				spellcheck="false"
			/>
		</div>
	</div>

	{#if error}
		<div class="error-banner animate-fade-in">
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width="16"
				height="16"
				viewBox="0 0 24 24"
				fill="none"
				stroke="currentColor"
				stroke-width="2"
				stroke-linecap="round"
				stroke-linejoin="round"
			>
				<circle cx="12" cy="12" r="10" />
				<line x1="12" y1="8" x2="12" y2="12" />
				<line x1="12" y1="16" x2="12.01" y2="16" />
			</svg>
			{error}
		</div>
	{/if}

	{#if parsedColor}
		<div class="stats-grid animate-fade-in">
			{#each stats as stat (stat.label)}
				<div class="stat-card {stat.css}">
					<span class="stat-label">{stat.label}</span>
					<span class="stat-value">{stat.value}</span>
				</div>
			{/each}
		</div>
	{/if}

	<div class="actions">
		<button class="btn btn-secondary" onclick={() => (inputText = '#ff6347')}>Load Sample</button>
		<button class="btn btn-tertiary" onclick={() => (inputText = '')} disabled={!inputText}
			>Clear</button
		>
	</div>
</div>

<style>
	.color-converter-container {
		max-width: 1200px;
		margin: 0 auto;
		padding: 1rem;
		font-family: var(--font-family-sans);
	}

	.tool-header {
		margin-bottom: 2rem;
	}

	.tool-header h1 {
		font-size: 2rem;
		font-weight: 700;
		color: var(--text);
		margin-bottom: 0.5rem;
	}

	.tool-description {
		font-size: 1rem;
		color: var(--text-secondary);
	}

	/* Picker Area */
	.picker-area {
		display: flex;
		justify-content: center;
		margin-bottom: 1.5rem;
	}

	.color-picker-wrapper {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 1rem;
	}

	#color-picker {
		width: 120px;
		height: 120px;
		padding: 0;
		border: 2px solid var(--border);
		border-radius: var(--radius);
		cursor: pointer;
	}

	#color-picker::-webkit-color-swatch-wrapper {
		padding: 0;
	}

	#color-picker::-webkit-color-swatch {
		border: none;
		border-radius: 6px;
	}

	#color-picker::-moz-color-swatch {
		border: none;
		border-radius: 6px;
	}

	#color-text-input {
		width: 100%;
		max-width: 400px;
		padding: 0.75rem 1rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--text);
		font-family: var(--font-family-mono);
		font-size: 1rem;
		text-align: center;
		outline: none;
		transition:
			border-color 0.2s,
			box-shadow 0.2s;
	}

	#color-text-input:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	/* Color Swatch */
	.color-swatch {
		border-radius: var(--radius);
		min-height: 80px;
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		gap: 0.25rem;
		margin-bottom: 1.5rem;
		border: 1px solid var(--border);
		position: relative;
		overflow: hidden;
	}

	.color-swatch::before {
		content: '';
		position: absolute;
		inset: 0;
		background-image: repeating-conic-gradient(#ccc 0% 25%, transparent 0% 50%);
		background-size: 16px 16px;
		opacity: 0.15;
	}

	.swatch-label {
		font-size: 0.75rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: rgba(255, 255, 255, 0.85);
		text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
		z-index: 1;
	}

	.swatch-value {
		font-size: 1.25rem;
		font-weight: 700;
		font-family: var(--font-family-mono);
		color: #ffffff;
		text-shadow: 0 1px 4px rgba(0, 0, 0, 0.6);
		z-index: 1;
	}

	/* Error Banner */
	.error-banner {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		padding: 1rem;
		margin-bottom: 1.5rem;
		background: rgba(239, 68, 68, 0.1);
		border: 1px solid rgba(239, 68, 68, 0.2);
		border-radius: var(--radius);
		color: #ef4444;
		font-size: 0.875rem;
	}

	[data-theme='dark'] .error-banner {
		background: rgba(239, 68, 68, 0.15);
		color: #f87171;
	}

	/* Stats Grid */
	.stats-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
		gap: 1rem;
		margin-bottom: 2rem;
	}

	.stat-card {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1rem;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		transition:
			transform 0.2s,
			box-shadow 0.2s;
	}

	.stat-card:hover {
		transform: translateY(-2px);
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
	}

	.stat-label {
		font-size: 0.75rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.stat-value {
		font-size: 1rem;
		font-weight: 700;
		color: var(--text);
		font-family: var(--font-family-mono);
		word-break: break-all;
	}

	.stat-card.blue {
		border-left: 4px solid #3b82f6;
	}
	.stat-card.cyan {
		border-left: 4px solid #06b6d4;
	}
	.stat-card.green {
		border-left: 4px solid #10b981;
	}
	.stat-card.emerald {
		border-left: 4px solid #10b981;
	}
	.stat-card.orange {
		border-left: 4px solid #f97316;
	}
	.stat-card.purple {
		border-left: 4px solid #8b5cf6;
	}

	.actions {
		display: flex;
		gap: 1rem;
		align-items: center;
	}

	.btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		padding: 0.75rem 1.5rem;
		font-size: 0.95rem;
		font-weight: 500;
		border-radius: var(--radius);
		border: 1px solid transparent;
		cursor: pointer;
		transition: all 0.15s ease-in-out;
		user-select: none;
	}

	.btn-secondary {
		background: var(--surface);
		color: var(--text);
		border-color: var(--border);
	}

	.btn-secondary:hover {
		background: var(--border);
	}

	.btn-tertiary {
		background: transparent;
		color: var(--text-secondary);
	}

	.btn-tertiary:hover {
		background: var(--surface);
		color: var(--text);
	}

	.btn-tertiary:disabled {
		opacity: 0.5;
		cursor: not-allowed;
		background: transparent;
		color: var(--text-secondary);
	}

	.animate-fade-in {
		animation: fadeIn 0.25s cubic-bezier(0.16, 1, 0.3, 1);
	}

	@keyframes fadeIn {
		from {
			opacity: 0;
			transform: translateY(4px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}
</style>
