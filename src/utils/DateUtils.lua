local DateUtils = {}

local oneDayDuration = 24 * 60 * 60


---@return table
function DateUtils.now()
    return os.date("*t")
end

---@param dateA table
---@param dateB table
---@return boolean if the two dates have the same day
function DateUtils.sameDay(dateA, dateB)
    return dateA.day == dateB.day
        and dateA.month == dateB.month
        and dateA.year == dateB.year
end

---@param dateA table
---@param dateB table
---@return boolean wether the two dates have a time difference less than one day
function DateUtils.within24Hours(dateA, dateB)
    return math.abs(os.difftime(os.time(dateB), os.time(dateA))) <= oneDayDuration
end

return DateUtils