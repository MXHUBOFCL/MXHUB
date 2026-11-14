export type Icon = number | string

export type WindowConfig = {
	name: string?,
	version: string?,
	theme: string?,
	accent: Color3?,
	menuKey: Enum.KeyCode?,
	community: boolean?,
	home: boolean?,
	settings: boolean?,
	discord: string?,
	discordStats: boolean?,
	donate: string?,
	icon: Icon?,
	image: Icon?,
	background: Icon?,
	logo: Icon?,
	iconRail: boolean?,
	toggleKeybinds: boolean?,
	translations: { [string]: { [string]: string } }?,
	language: string?,
	configFolder: string?,
}

export type Element = {
	Value: any,
	Set: (self: Element, value: any) -> (),
	SetIcon: (self: Element, value: Icon?) -> (),
	SetIconColor: (self: Element, color: Color3) -> (),
}

export type SegmentedConfig = { name: string, options: { string }, value: string?, flag: string?, icon: Icon?, description: string?, save: boolean?, callback: ((string) -> ())? }
export type StepperConfig = { name: string, range: { number }?, increment: number?, value: number?, flag: string?, icon: Icon?, description: string?, save: boolean?, callback: ((number) -> ())? }
export type ProgressConfig = { name: string, range: { number }?, value: number?, format: ((number, number) -> string)?, color: Color3?, icon: Icon?, description: string? }
export type ProgressElement = { Value: number, Set: (self: ProgressElement, value: number, instant: boolean?) -> (), Get: (self: ProgressElement) -> number, SetColor: (self: ProgressElement, color: Color3) -> () }

export type WebhookPayload = {
	content: string?,
	username: string?,
	avatar: string?,
	allowMentions: boolean?,
	embeds: { { title: string?, description: string?, url: string?, color: (Color3 | number)?, timestamp: (boolean | string)?, footer: (string | { text: string })?, author: { name: string }?, thumbnail: string?, image: string?, fields: { { name: string, value: string, inline: boolean? } }? } }?,
}

export type ImageConfig = {
	image: Icon?,
	height: number?,
	width: number?,
	fit: ("contain" | "cover" | "stretch")?,
	align: ("left" | "center" | "right")?,
	aspectRatio: number?,
	cornerRadius: number?,
	transparency: number?,
	color: Color3?,
	border: (boolean | Color3)?,
	background: (boolean | Color3)?,
}

export type ImageElement = {
	Instance: ImageLabel,
	SetImage: (self: ImageElement, value: Icon?) -> (),
	SetColor: (self: ImageElement, color: Color3) -> (),
	SetTransparency: (self: ImageElement, value: number) -> (),
	SetFit: (self: ImageElement, mode: string) -> (),
	SetAspectRatio: (self: ImageElement, value: number?) -> (),
	SetSize: (self: ImageElement, width: number?, height: number?) -> (),
}

export type ButtonConfig = { name: string, callback: (() -> ())?, icon: Icon? }
export type ToggleConfig = { name: string, flag: string?, value: boolean?, keybind: boolean?, description: string?, callback: ((boolean) -> ())? }
export type SliderConfig = { name: string, flag: string?, range: { number }?, increment: number?, value: number?, suffix: string?, callback: ((number) -> ())? }
export type DropdownConfig = { name: string, flag: string?, options: { string }, multiSelect: boolean?, value: (string | { string })?, callback: ((any) -> ())? }
export type InputConfig = { name: string, flag: string?, numeric: boolean?, value: string?, placeholder: string?, callback: ((string) -> ())? }
export type KeybindConfig = { name: string, flag: string?, value: Enum.KeyCode?, mode: string?, callback: ((any) -> ())?, changed: ((any) -> ())? }
export type ColorPickerConfig = { name: string, flag: string?, color: Color3?, callback: ((Color3, number) -> ())? }

export type Tab = {
	CreateSection: (self: Tab, config: { name: string, side: string?, open: boolean?, icon: Icon? }) -> Tab,
	CreateSubTab: (self: Tab, name: string) -> Tab,
	CreateButton: (self: Tab, config: ButtonConfig) -> { SetTitle: (self: any, text: string) -> () },
	CreateToggle: (self: Tab, config: ToggleConfig) -> Element,
	CreateSlider: (self: Tab, config: SliderConfig) -> Element,
	CreateDropdown: (self: Tab, config: DropdownConfig) -> Element,
	CreateInput: (self: Tab, config: InputConfig) -> Element,
	CreateKeybind: (self: Tab, config: KeybindConfig) -> Element,
	CreateColorPicker: (self: Tab, config: ColorPickerConfig) -> Element,
	CreateParagraph: (self: Tab, config: { name: string?, content: string?, icon: Icon? }) -> any,
	CreateLabel: (self: Tab, config: { name: string } | string) -> any,
	CreateDivider: (self: Tab) -> any,
	CreateImage: (self: Tab, config: ImageConfig) -> ImageElement,
	CreateSegmented: (self: Tab, config: SegmentedConfig) -> Element,
	CreateStepper: (self: Tab, config: StepperConfig) -> Element,
	CreateProgress: (self: Tab, config: ProgressConfig) -> ProgressElement,
	CreateCharacter: (self: Tab, config: { side: string?, height: number?, target: (Player | number | string)?, label: string?, name: string? }) -> { SetTarget: (self: any, target: any) -> (), Refresh: (self: any) -> () },
	SetIcon: (self: Tab, value: Icon?) -> Tab,
	SetSectionIcon: (self: Tab, value: Icon?) -> Tab,
	Select: (self: Tab) -> (),
}

export type PopupConfig = {
	title: string?,
	subtitle: string?,
	boxes: { { title: string?, description: string?, icon: Icon? } }?,
	options: { { text: string, style: string?, callback: (() -> ())? } }?,
	dismissable: boolean?,
}

export type Window = {
	flags: { [string]: Element },
	CreateSection: (self: Window, config: { name: string }) -> Window,
	CreateTab: (self: Window, config: { name: string, icon: Icon? }) -> Tab,
	Popup: (self: Window, config: PopupConfig) -> { Close: () -> () },
	ChangeTheme: (self: Window, name: string, accent: (Color3 | string)?) -> (boolean, string),
	SetLanguage: (self: Window, name: string) -> (),
	ShowHotkeys: (self: Window, state: boolean?) -> Window,
	OnUnload: (self: Window, callback: () -> ()) -> Window,
	GetFlag: (self: Window, flag: string) -> any,
	Destroy: (self: Window) -> (),
}

export type MXHUB = {
	Version: string,
	Discord: {
		ParseInvite: (value: string) -> string?,
		Stats: (invite: string, force: boolean?) -> ({ Code: string, Name: string?, Members: number, Online: number? }?, string?),
	},
	Webhook: {
		Validate: (url: string) -> boolean,
		New: (url: string) -> ({ Send: (self: any, payload: (string | WebhookPayload)) -> (boolean, number?, string?) }?, string?),
	},
	Image: { Normalize: (value: Icon?) -> string?, Thumbnail: (kind: string?, id: number, width: number?, height: number?) -> string },
	Theme: { Names: () -> { string }, Set: (patch: { Preset: string?, Accent: (Color3 | boolean)? }) -> (boolean, string) },
	CreateWindow: (self: MXHUB, config: WindowConfig) -> Window,
}

return {}
