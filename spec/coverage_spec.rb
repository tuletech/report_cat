describe 'coverage' do

  it 'has a spec for every file' do
    [
      'app',
      'lib',
    ].each do |dir|
      Dir.glob( File.join( ENGINE_ROOT, dir, '**', '*.{rb,erb,rake}' ) ) do |path|
        next if File.basename( path ) =~ /^_/
        path = path.sub( /#{ENGINE_ROOT}\//, '' )
        expect( path ).to have_a_spec
      end
    end
  end
end
