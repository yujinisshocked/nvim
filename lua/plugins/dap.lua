return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configure dap-ui to only show the console and controls
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "console", size = 0 }, -- Only show the console
            },
            size = 0,
            position = "top",
          },
        },
        controls = {
          enabled = true, -- Enable controls in the console panel
          element = "console", -- Show controls in the console panel
        },
      })

      -- Open dap-ui when debugging starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
      end

      -- Close dap-ui when debugging ends
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Dart/Flutter DAP config
      dap.adapters.dart = {
        type = "executable",
        command = "flutter",
        args = { "debug-adapter" },
      }
      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter Program",
          program = "${workspaceFolder}/lib/main.dart",
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
}

