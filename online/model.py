from main import db

# Initial code source:
# https://flask-sqlalchemy.palletsprojects.com/en/2.x/quickstart/

class Location(db.Model):
    __tablename__ = 'location'
    loc_id = db.Column(db.Integer(), primary_key=True)
    lat_ = db.Column(db.Float(), nullable=True)
    long_ = db.Column(db.Float(), nullable=True)

class User(db.Model):
    __tablename__ = 'user'
    uid = db.Column(db.Integer(), primary_key=True)
    email = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    curr_loc = db.Column(db.Integer(), db.ForeignKey('location.loc_id'))

    def __repr__(self):
        return '<User %r>' % self.email

class UserLocations(db.Model):
    __tablename__ = 'user_locations'
    uid = db.Column(db.Integer(), db.ForeignKey('user.uid'), primary_key=True)
    loc_id = db.Column(db.Integer(), db.ForeignKey('location.loc_id'), primary_key=True)