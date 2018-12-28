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

  describe "データクラスの定義の変更" do
    let(:definition) { { x: Fixnum } }

    it '定義の変更の影響を受けないこと' do
      klass = KtDataClass.create(definition)
      definition[:x] = String
      expect{ klass.new(x: 1) }.not_to raise_error(ArgumentError, /type mismatch/)
    end
  end

  describe "複数クラスの定義" do
    context 'Array<Class>指定時' do
      let(:klass) { KtDataClass.create(x: [Fixnum, NilClass, String]) }

      it '定義されている型が使えること' do
        expect(klass.new(x: 1).x).to eq(1)
        expect(klass.new(x: nil).x).to be_nil
        expect(klass.new(x: "1").x).to eq("1")
      end
    end

    context 'UnionSyntax利用時' do
      using KtDataClass::UnionSyntax
      let(:klass) { KtDataClass.create(x: Fixnum | NilClass | String) }

      it '定義されている型が使えること' do
        expect(klass.new(x: 1).x).to eq(1)
        expect(klass.new(x: nil).x).to be_nil
        expect(klass.new(x: "1").x).to eq("1")
      end
    end
  end

  describe 'Hash変換' do
    let(:instance) { KtDataClass.create(x: Fixnum, y: NilClass).new(x: 1, y: nil) }
    it '正しくHashに変換されること' do
      expect(instance.hash).to eq({x: 1, y: nil})
      expect(instance.to_h).to eq({x: 1, y: nil})
      expect(instance.to_hash).to eq({x: 1, y: nil})
    end
  end

  describe 'String変換' do
    let(:instance) { KtDataClass.create(x: Fixnum, y: NilClass).new(x: 1, y: nil) }
    it 'ハッシュ文字列に変換されること' do
      expect(instance.to_s).to eq({x: 1, y: nil}.to_s)
    end
  end

  describe 'equality' do
    let(:klass1) { KtDataClass.create(x: Fixnum) }
    let(:klass2) { KtDataClass.create(x: Fixnum) }
    let(:klass3) { KtDataClass.create(x: Float) }
    let(:klass4) { KtDataClass.create(x: Fixnum, y: NilClass) }

    describe '同一のクラスの２つの同値インスタンスの比較' do
      let(:instance1) { klass1.new(x: 1) }
      let(:instance2) { klass1.new(x: 1) }

      it { expect(instance1.equal?(instance2)).to eq(false) }
      it { expect(instance1 == instance2).to eq(true) }
      it { expect(instance1 <=> instance2).to eq(0) }
       it { expect(instance1.eql?(instance2)).to eq(true) }
      it { expect(instance1 === instance2).to eq(true) }
    end

    describe '同一のクラスの２つの異なる値のインスタンスの比較' do
      let(:instance1) { klass1.new(x: 1) }
      let(:instance2) { klass1.new(x: 2) }

      it { expect(instance1.equal?(instance2)).to eq(false) }
      it { expect(instance1 == instance2).to eq(false) }
      it { expect(instance1 <=> instance2).not_to eq(0) }
      it { expect(instance1.eql?(instance2)).to eq(false) }
      it { expect(instance1 === instance2).to eq(false) }
    end

    describe '定義が同じで、異なるクラスの２つのインスタンスの比較' do
      let(:instance1) { klass1.new(x: 1) }
      let(:instance2) { klass2.new(x: 1) }

      it { expect(instance1.equal?(instance2)).to eq(false) }
      it { expect(instance1 == instance2).to eq(true) }
      it { expect(instance1 <=> instance2).to eq(0) }
      it { expect(instance1.eql?(instance2)).to eq(false) }
      it { expect(instance1 === instance2).to eq(true) }
    end

    describe '定義が異なるが値レベルでは同じクラスの２つのインスタンスの比較' do
      let(:instance1) { klass1.new(x: 1) }
      let(:instance2) { klass3.new(x: 1.0) }

      it { expect(instance1.equal?(instance2)).to eq(false) }
      it { expect(instance1 == instance2).to eq(true) }
      it { expect(instance1 <=> instance2).to eq(0) }
      it { expect(instance1.eql?(instance2)).to eq(false) }
      it { expect(instance1 === instance2).to eq(true) }
    end

    describe 'クラス定義も値も異なるインスタンスの比較' do
      let(:instance1) { klass1.new(x: 1) }
      let(:instance2) { klass4.new(x: 1, y: nil) }

      it { expect(instance1.equal?(instance2)).to eq(false) }
      it { expect(instance1 == instance2).to eq(false) }
      it { expect(instance1 <=> instance2).not_to eq(0) }
      it { expect(instance1.eql?(instance2)).to eq(false) }
      it { expect(instance1 === instance2).to eq(false) }
    end
  end
end
