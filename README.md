<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./README/bayalogo-white.png">
    <source media="(prefers-color-scheme: light)" srcset="./README/bayalogo-dark.png">
    <img alt="baya logo" src="./README/bayalogo.png">
  </picture>
</p>
<h2 align="center">
  A Roblox script built from the ground up for your precise needs!
  <br/>
  Rise up to the top while remaining completely untouchable.
</h2>

## Contacts
<br/>

## Usage
1. Download the specific scripting utility of your choice.
2. Execute the provided loadstring below.
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/fisiaque/BayaForRobloxTest/main/loader.lua", true))()
```

## Possible Issues
Half of the time its usually the scripting utility at fault, please make sure the utility meets certain quality standards such as.
1. Supporting file functions & the debug library.
2. Not implementing lua generated / half baked versions of such functions resulting in unintended behavior.
3. Maintaing the same behavior across all usages of said functions.
### User Issues
If its not the supposed utility at fault, please try some troubleshooting steps.
1. Deleting the BayaUI folder (WITH THE GAME CLOSED).
2. Making sure you have connection to [the main loadstring.](https://raw.githubusercontent.com/fisiaque/BayaForRobloxTest/refs/heads/main/loader.lua)
3. Ensuring no external script is conflicting with baya.

## Get Time for Announcements
```luau
print(os.time({
	year=2025, month=5, day=12, -- Date components
	hour=13, min=35, sec=0 -- Time components
})) --> 1586
```