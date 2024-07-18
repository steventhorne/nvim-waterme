# nvim-waterme
An nvim plugin that reminds you to drink water.

<!-- TOC -->

- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)

<!-- /TOC -->

## Requirements

- Neovim 0.10+
- nvim-notify

## Installation

<details>
    <summary>lazy.nvim</summary>

```lua
{
  "steventhorne/nvim-waterme",
  dependencies = {
    { "rcarriga/nvim-notify" },
  },
  config = function()
    require("nvim-waterme").setup()
  end
}
```

</details>

<details>
    <summary>Packer</summary>

```lua
use {
  "steventhorne/nvim-waterme",
  requires = { "rcarriga/nvim-notify" },
  config = function()
    require("nvim-waterme").setup()
  end
}
```

</details>

## Configuration

```lua
require("nvim-waterme").setup({
  interval = 900, -- 15 minutes
  message = "Time to drink water!",
})
```

Vim highlight `WatermeNormal` can also be changed to customize the notification border.
