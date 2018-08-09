class Service

  def initialize

    @@cluster = Cassandra.cluster(
        username: 'cassandra',
        password: 'cassandra',
        hosts: ['127.0.0.1']
    )

    @@cluster.each_host do |host|
      puts "Host #{host.ip}: id=#{host.id} datacenter=#{host.datacenter} rack=#{host.rack}"
    end

    @keyspace = 'user_keyspace'
    @session  = @@cluster.connect(@keyspace)

  end

  def query
    begin
      future = @session.execute_async('SELECT * FROM user') #fully asynchronous
      list = []
      future.on_success do |rows|
        rows.each do |row|
          list << row
        end
      end
      future.join
      return list
    rescue => e
      puts e.to_s
    end
  end

  def insert(first_name, last_name)
    begin
      statement = @session.prepare('INSERT INTO user (first_name, last_name) VALUES (?, ?)')
      @msg = @session.execute(statement, arguments: [first_name, last_name])
      return @msg
    rescue => e
      puts e.to_s
    end''
  end

  def delete(first_name)
    begin
      statement = @session.execute_async('DELETE FROM USER WHERE first_name=?', arguments: [first_name])
      return statement
    rescue => e
      puts e.to_s
    end
  end

end
