require 'spec_helper'

describe MoviesController do
	describe 'add director to existing movie' do
		it 'should add add the director info to an existing movie' do
			m = mock('Movie', :title => 'Alien', :rating => 'R', :director => 'Ridley Scott', :release_date => '1979-05-25')
			Movie.stub(:find).and_return(m)
			m.should_receive(:update_attributes!)
			put :update, :id => 1, :movie => m 
		end
		it 'should show the added director info in an existing movie' do
			m = mock('Movie', :title => 'Alien', :rating => 'R', :director => 'Ridley Scott', :release_date => '1979-05-25')
			Movie.stub(:find).and_return(m)
			m.stub(:update_attributes!).and_return(m)
			put :update, :id => 1, :movie => m
			response.should redirect_to(movie_path(m))
		end
	end

	describe 'find movies by the same director' do
		context 'with director info' do
			it 'should find all movies by the same director' do 
				m = Movie.create({:id => 1})
				Movie.should_receive(:find_all_by_director)
				get :find_with_same_director, :id => m.id 
			end
			it 'should return movies with the same director to the template' do
				m = Movie.create({:id => 1})
				fake_results = [mock('Movie'), mock('Movie')]
				Movie.stub(:find_all_by_director).and_return(fake_results)
				get :find_with_same_director, :id => m.id 
				assigns(:movies).should == fake_results
			end
			it 'should render the find with same director page' do
				m1 = Movie.create({:id => 1, :title => 'Star Wars', :rating => 'PG', :director=> 'George Lucas', :release_date => '1977-05-25'})
				m2 = Movie.create({:id => 2, :title => 'THX-1138', :rating => 'R', :director => 'George Lucas', :release_date => '1971-03-11'})
				get :find_with_same_director, :id => m1.id
				response.should render_template('find_with_same_director')
			end
		end
		context 'without director info' do
			it 'should redirect to the index page' do
				m = Movie.create({:id => 1})
				get :find_with_same_director, :id => m.id
				response.should redirect_to('/movies')
			end
		end
	end
	describe 'add new movie' do
		it 'should create a new database record and assign it to the movie instance variable' do
			m = mock('Movie', { :title => 'Alien', :rating => 'R', :release_date => '1979-05-25' })
			Movie.stub(:create!).and_return(m)
			post :create, :movie => m
			assigns(:movie).should == m 
		end
	end
	describe 'delete new movie' do
		it 'should delete a database record and redirect to the index page' do
			m = Movie.create!({ :title => 'Alien', :rating => 'R', :release_date => '1979-05-25' })
			delete :destroy, :id => m.id 
			response.should redirect_to('/movies')
		end
	end
end
