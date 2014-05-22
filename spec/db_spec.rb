require 'spec_helper'
require 'pry-debugger'

########
## DB ##
########

describe 'db' do
  let(:db) do
    PL.db.reset_tables
    PL.db
  end

  it 'exits' do
    expect(DB).to be_a(Class)
    db
  end

  it 'returns a db' do
    expect(db).to be_a(DB)
  end

  xit 'has the correct tables' do

  end

  it 'is a singleton' do
    db1 = PL.db
    db2 = PL.db
    expect(db1).to be(db2)
  end

  it 'has the correct number of tables' do
    tables = db.get_all_tables
    expect(tables.size).to eq(3)
    expect(tables).to include("users", "playlists", "songs")
  end

  describe 'users' do
    let (:user1) do
      {
        name: "user",
        password: "abcd"
      }
      db.create_user(user1)
    end
    describe 'build_user' do
      it 'should build a user object' do
        user = db.build_user(name: "user", password: "abcd")
        expect(user).to be_a(PL::User)
      end
    end

    describe 'create_user' do
      it 'adds a user record to db' do
        user1
        command = "SELECT * FROM users;"
        records = db.execute(command)
        expect(records.size).to eq(1)
      end

      it 'creates user in db with correct attributes' do
        user1
        command = "SELECT * FROM users;"
        records = db.execute(command)
        expect(records.first.size).to eq(3)
        expect(records.first.first).to eq(1)
        expect(records.first[1]).to eq("user")
        expect(records.first.last).to eq("abcd")
      end
    end
  end
end



































# test
