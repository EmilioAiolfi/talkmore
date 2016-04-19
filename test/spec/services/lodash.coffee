'use strict'

describe 'lodash', ->
  beforeEach module('talkmoreApp')
  describe '_', ->
    it 'should be defined', inject((_) ->
      expect(_).not.toBeNull
    )

    it 'should have toArray() defined', inject((_) ->
      expect(_.toArray).toBeDefined()
    )
