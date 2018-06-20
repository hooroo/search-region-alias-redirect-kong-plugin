local subject = require "kong.plugins.search-region-alias-redirect.access"

describe("Access", function()
    it("isNumber", function()
        assert.is_true(subject.isNumbersOnly('54354'))
        assert.is_true(subject.isNumbersOnly('1234563131'))
        assert.is_false(subject.isNumbersOnly('ACV54354'))
        assert.is_false(subject.isNumbersOnly('acvb54354'))
        assert.is_false(subject.isNumbersOnly('54aadsd'))
        assert.is_false(subject.isNumbersOnly('54ASvcx'))
        assert.is_false(subject.isNumbersOnly('123 Fake Street, FakeTown'))
    end)

end)
