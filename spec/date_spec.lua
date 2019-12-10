local DateUtils = require('src.utils.DateUtils')
local lume = require('lib.lume')

describe("Date utils testing", function()

    it("Should check when it's the same day", function()
        local now1 = DateUtils.now()
        local now2 = lume.clone(now1)

        assert.is_true( DateUtils.sameDay(now1, now2))

        now2.day = now2.day + 1
        assert.is_false(DateUtils.sameDay(now1, now2))

        now2.day = now1.day
        now2.month = now2.month + 1
        assert.is_false(DateUtils.sameDay(now1, now2))

        now2.month = now1.month
        now2.year = now1.year - 20
        assert.is_false(DateUtils.sameDay(now1, now2))
    end)

    it("Should check when it's withing 24 hours", function()
        local now1 = DateUtils.now()
        local now2 = lume.clone(now1)

        assert.is_true(DateUtils.within24Hours(now1, now2))

        now2.year = now1.year + 200
        assert.is_false(DateUtils.within24Hours(now1, now2))

        now2 = lume.clone(now1)
        now2.sec = math.max(now1.sec + 5, 60)
        assert.is_true(DateUtils.within24Hours(now1, now2))

        local day0 = {year = 0, month = 1, day = 1, hours = 0, min = 0, sec = 0}
        local day1 = {year = 1, month = 1, day = 1, hours = 0, min = 0, sec = 0}
        assert.is_false(DateUtils.within24Hours(day0, day1))

        day0 = {year = 0, month = 1, day = 1, hours = 0, min = 0, sec = 0}
        day1 = {year = 0, month = 1, day = 2, hours = 0, min = 0, sec = 0}
        assert.is_true(DateUtils.within24Hours(day0, day1))

        day0 = {year = 0, month = 1, day = 1, hours = 0, min = 0, sec = 0}
        day1 = {year = 0, month = 1, day = 2, hours = 0, min = 0, sec = 1}
        assert.is_false(DateUtils.within24Hours(day0, day1))
    end)

end)