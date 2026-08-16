if getgenv().BeatSpoof then
    getgenv().BeatSpoof.Enabled = true
    return
end

local State = {
    Enabled = true,
    Clean = 0,
    Blocked = 0,
    Beats = {},
}
getgenv().BeatSpoof = State

local BeatMinBytes = 8

local function IsGuidName(Name)
    return #Name == 36 and Name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-") ~= nil
end

local function Handle(Remote, ...)
    local Payload = ...
    if type(Payload) ~= "string" or not IsGuidName(Remote.Name) then
        return false
    end

    local Entry = State.Beats[Remote.Name]
    if not Entry then
        Entry = { Longest = 0 }
        State.Beats[Remote.Name] = Entry
    end

    if #Payload > Entry.Longest then
        Entry.Longest = #Payload
        Entry.Verdict = Payload:byte(4)
    end

    if Entry.LastClean and Entry.Longest >= BeatMinBytes then
        if #Payload < Entry.Longest or Payload:byte(4) ~= Entry.Verdict then
            State.Blocked = State.Blocked + 1
            return true, Entry.LastClean
        end
    end

    if #Payload >= Entry.Longest then
        Entry.LastClean = table.pack(...)
        State.Clean = State.Clean + 1
    end

    return false
end

local function Install(Method)
    local Original
    Original = hookfunction(
        Method,
        newcclosure(function(Self, ...)
            if State.Enabled then
                local Ok, Blocked, Beat = pcall(Handle, Self, ...)
                if Ok and Blocked and Beat then
                    return Original(Self, table.unpack(Beat, 1, Beat.n))
                end
            end
            return Original(Self, ...)
        end)
    )
end

local ProbeEvent = Instance.new("RemoteEvent")
local ProbeFunction = Instance.new("RemoteFunction")

Install(ProbeEvent.FireServer)
Install(ProbeFunction.InvokeServer)

ProbeEvent:Destroy()
ProbeFunction:Destroy()
