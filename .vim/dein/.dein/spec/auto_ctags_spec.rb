require 'spec_helper'

def file_exist(file)
  sleep 0.05
  File.exist?(file).should be_true
  File.delete(file)
end

def set_file_content(file, string)
  string = normalize_string_indent(string)
  File.open(file, 'w'){ |f| f.write(string) }
  File.absolute_path(file)
end

def vimrc(string)
  path = set_file_content('vimrc', string)
  vim.source path
end

describe "Auto Ctags" do
  let(:filename) { 'test.txt' }
  before do
    vim.edit filename
  end

  specify ":Ctags" do
    vim.command 'Ctags'

    file_exist 'tags'
  end

  specify "let g:auto_ctags = 1" do

    vimrc <<-EOF
      let g:auto_ctags = 1
    EOF

    vim.write

    file_exist 'tags'
  end

  specify "let g:auto_ctags_directory_list = ['.git']" do

    vimrc <<-EOF
      let g:auto_ctags_directory_list = ['.git']
    EOF

    Dir.mkdir '.git'
    vim.command 'Ctags'

    file_exist '.git/tags'
  end

  specify "let g:auto_ctags_directory_list = ['.svn', '.git', '.']" do

    vimrc <<-EOF
      let g:auto_ctags_directory_list = ['.svn', '.git', '.']
    EOF

    vim.command 'Ctags'
    file_exist 'tags'
  end

  #specify "let g:auto_ctags_tags_name = 'huge.tags'" do

  #  vimrc <<-EOF
  #    let g:auto_ctags_tags_name = 'huge.tags'
  #  EOF

  #  vim.command 'Ctags'
  #  file_exist 'huge.tags'
  #end

  #specify "let g:auto_ctags_filetype_mode = 1" do
  #  vimrc <<-EOF
  #    let g:auto_ctags_filetype_mode = 1
  #  EOF

  #  vim.set 'filetype' 'vim'
  #  vim.command 'Ctags'
  #  file_exist 'vim.tags'
  #end

end
