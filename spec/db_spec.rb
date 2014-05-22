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
      data = {
        name: "user1",
        password: "abcd"
      }
      db.create_user(data)
    end

    let (:user2) do
      data = {
        name: "user2",
        password: "123"
      }
      db.create_user(data)
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
        records = db.db.execute(command)
        expect(records.size).to eq(1)
      end

      it 'creates user in db with correct attributes' do
        user1
        command = "SELECT * FROM users;"
        records = db.db.execute(command)
        expect(records.first.size).to eq(3)
        expect(records.first.first).to eq(1)
        expect(records.first[1]).to eq("user1")
        expect(records.first.last).to eq("abcd")
      end
    end

    describe 'get_user_by_name' do
      it 'return user object' do
        user1
        expect(db.get_user_by_name("user1")).to be_a(PL::User)
      end

      it 'gets user with correct attributes' do
        user1
        user2
        result = db.get_user_by_name("user1")

        expect(result.name).to eq("user1")
        expect(result.password).to eq("abcd")
      end
    end
  end
end



































# test
