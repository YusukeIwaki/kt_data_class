require 'spec_helper'

RSpec.describe KtDataClass do
  it "has a version number" do
    expect(KtDataClass::VERSION).not_to be nil
  end

  describe "データクラスの作成" do
    let(:klass) { KtDataClass.create(x: Fixnum, y: String) }

    context '初期化パラメータが正しい場合' do
      let(:instance) { klass.new(x: 123, y: "456") }
      it '正しく初期化されること' do
        expect(instance.x).to eq(123)
        expect(instance.y).to eq("456")
      end

      it '値の上書きができないこと' do
        expect{ instance.x = 789 }.to raise_error
        expect{ instance.y = "789" }.to raise_error
      end
    end

    context '初期化パラメータが足りない場合' do
      let(:instance) { klass.new(x: 123) }
      it 'ArgumentErrorになること' do
        expect{ instance }.to raise_error(ArgumentError, /missing keyword: y/)
      end
    end

    context '初期化パラメータの型が誤っている場合' do
      let(:instance) { klass.new(x: 123, y: 456) }
      it 'ArgumentErrorになること' do
        expect{ instance }.to raise_error(ArgumentError, /type mismatch: y must be a String/)
      end
    end

    context '未知の初期化パラメータが指定された場合' do
      let(:instance) { klass.new(x: 123, y: "456", z: 789) }
      it 'ArgumentErrorになること' do
        expect{ instance }.to raise_error(ArgumentError, /unknown keyword: z/)
      end
    end
  end
end
