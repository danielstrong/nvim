local M = {}

function M.create_prompt_store_entry()
    -- TODO: if in normal mode take the text from the line of the cursor, if in visual mode take all the selected text
    -- then open a floating window over the middle of the screen with a new buffer with that text in it
    -- when closing the window while saving it should ask you what to name the file, it should be saved in custom-plugins/prompt-store/prompts this folder is relative to the configuration root of the running nvim instance
    -- so for instance if you enter the name my-prompt.md it would be saved at custom-plugins/prompt-store/prompts/my-prompt.md relatie to the configuration root of the running nvim instance
end
function M.edit_prompt_store_entry()
    --TODO: shows a fzf-lua picker to choose a file from custom-plugins/prompt-store/prompts this folder is relative to the configuration root of the running nvim instance
    --fzf-lua should fuzzy match based on the file names
    -- one file can be chosen only, after choosing it a floating window over the middle of the screen shows that lets you edit the file and then close it
end
function M.paste_prompt_store_entry()
    --TODO: shows a fzf-lua picker to choose a file from custom-plugins/prompt-store/prompts this folder is relative to the configuration root of the running nvim instance
    --fzf-lua should fuzzy match based ont he file names
    -- one or many files can be chosen with fzf-lua after seelcting their contents are pasted into the document linewie at the locaiton of the cursor
end
return M
