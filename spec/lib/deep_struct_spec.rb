require 'rails_helper'

describe DeepStruct do
  describe '.new' do
    it 'works well with nested hashes' do
      complex_hash = {
        hash_key_1: 'hash_key_1_value',
        hash_key_2: 'hash_key_2_value',
        hash_key_3: {
          inner_hash_key_1: 'inner_hash_key_1_value',
          inner_hash_key_2: 'inner_hash_key_2_value',
          inner_hash_key_3: {
            deep_hash_key_1: 'deep_hash_key_1_value',
            deep_hash_key_2: 'deep_hash_key_2_value',
            deep_hash_key_3: {
              value: 'treasure'
            }
          }
        }
      }

      ds = DeepStruct.new(complex_hash)

      expect(ds.hash_key_1).to eq('hash_key_1_value')
      expect(ds.hash_key_2).to eq('hash_key_2_value')
      expect(ds.hash_key_3.inner_hash_key_1).to eq('inner_hash_key_1_value')
      expect(ds.hash_key_3.inner_hash_key_2).to eq('inner_hash_key_2_value')
      expect(ds.hash_key_3.inner_hash_key_3.deep_hash_key_1).to eq('deep_hash_key_1_value')
      expect(ds.hash_key_3.inner_hash_key_3.deep_hash_key_2).to eq('deep_hash_key_2_value')
      expect(ds.hash_key_3.inner_hash_key_3.deep_hash_key_3.value).to eq('treasure')
    end

    it 'works well with arrays' do
      hash = {
        some_array: [
          {
            some_element_key: 'some_element_value'
          },
          {
            some_inner_array: [
              {
                some_inner_array_element_key: 'some_inner_array_element_value'
              }
            ]
          }
        ]
      }

      ds = DeepStruct.new(hash)

      expect(ds.some_array[0].some_element_key).to eq('some_element_value')
      expect(ds.some_array[1].some_inner_array[0].some_inner_array_element_key).to eq('some_inner_array_element_value')
    end
  end

  describe '.collection' do
    before :each do
      @hash_1 = {
        key_1: 'value_1',
        key_2: 'value_2'
      }

      @hash_2 = {
        key_3: 'value_3',
        key_4: 'value_4'
      }
    end

    it 'creates array of self' do
      array = [@hash_1, @hash_2]
      collection = DeepStruct.collection array
      handmade_array = [ DeepStruct.new(@hash_1), DeepStruct.new(@hash_2) ]

      expect(collection).to eq(handmade_array)
    end

    it 'works with a single element' do
      collection = DeepStruct.collection @hash_1
      handmade_array = [ DeepStruct.new(@hash_1) ]

      expect(collection).to eq(handmade_array)
    end
  end

  describe '.to_h' do
    it 'returns initial hash' do
      initial_hash = {
        hash_key_1: 'hash_key_1_value',
        hash_key_2: 'hash_key_2_value',
        hash_key_3: {
          inner_hash_key_1: 'inner_hash_key_1_value',
          inner_hash_key_2: 'inner_hash_key_2_value',
          inner_hash_key_3: {
            deep_hash_key_1: 'deep_hash_key_1_value',
            deep_hash_key_2: 'deep_hash_key_2_value',
            deep_hash_key_3: {
              value: 'treasure'
            }
          }
        }
      }
      restored_hash = DeepStruct.new(initial_hash).to_h

      expect(restored_hash).to eq(initial_hash)
    end
  end
end
