local viewers = {'zhiva', 'zhiva-editor'}
local editors = {'zhiva-editor'}
local admins = {'zhiva-admin'}

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function IncomingHttpRequestFilter(method, uri, ip, username, httpHeaders)
  if method == 'GET' and has_value(viewers, username) then
--     Read-only access (only GET method is allowed)
    return true
  elseif has_value(admins, username) then
    -- Read-write access for administrator (any HTTP method is allowed)
    return true
  elseif string.find(uri, "tools/") then
    -- Access is disallowed for any tools if not admin user (prevent CSRF attacks when executing remove Lua scripts)
    return false
  elseif method == 'POST' and has_value(editors, username) then
    -- Read-write access (update/store) for editors (only POST method is allowed)
    return true
  else
    -- Access is disallowed by default
    return false
  end
end