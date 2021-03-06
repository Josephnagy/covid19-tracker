"""empty message

Revision ID: d446b2b9b340
Revises: 671353e4a915
Create Date: 2020-04-13 02:32:32.505718

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'd446b2b9b340'
down_revision = '671353e4a915'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('user_locations',
    sa.Column('pair_id', sa.Integer(), nullable=False),
    sa.Column('uid', sa.Integer(), nullable=True),
    sa.Column('loc_id', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['loc_id'], ['location.loc_id'], ),
    sa.ForeignKeyConstraint(['uid'], ['user.uid'], ),
    sa.PrimaryKeyConstraint('pair_id')
    )
    op.add_column(u'location', sa.Column('lat_', sa.Float(), nullable=True))
    op.add_column(u'location', sa.Column('loc_id', sa.Integer(), nullable=False))
    op.add_column(u'location', sa.Column('long_', sa.Float(), nullable=True))
    op.drop_column(u'location', 'latitude')
    op.drop_column(u'location', 'id')
    op.drop_column(u'location', 'longitude')
    op.add_column(u'user', sa.Column('curr_loc', sa.Integer(), nullable=True))
    op.add_column(u'user', sa.Column('email', sa.String(length=80), nullable=False))
    op.add_column(u'user', sa.Column('password', sa.String(length=120), nullable=False))
    op.add_column(u'user', sa.Column('uid', sa.Integer(), nullable=False))
    op.create_unique_constraint(None, 'user', ['email'])
    op.create_foreign_key(None, 'user', 'location', ['curr_loc'], ['loc_id'])
    op.drop_column(u'user', 'username')
    op.drop_column(u'user', 'passwordHash')
    op.drop_column(u'user', 'dynamicSalt')
    op.drop_column(u'user', 'id')
    op.drop_column(u'user', 'location')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column(u'user', sa.Column('location', sa.INTEGER(), nullable=True))
    op.add_column(u'user', sa.Column('id', sa.INTEGER(), nullable=False))
    op.add_column(u'user', sa.Column('dynamicSalt', sa.VARCHAR(length=30), nullable=False))
    op.add_column(u'user', sa.Column('passwordHash', sa.VARCHAR(length=120), nullable=False))
    op.add_column(u'user', sa.Column('username', sa.VARCHAR(length=80), nullable=False))
    op.drop_constraint(None, 'user', type_='foreignkey')
    op.drop_constraint(None, 'user', type_='unique')
    op.drop_column(u'user', 'uid')
    op.drop_column(u'user', 'password')
    op.drop_column(u'user', 'email')
    op.drop_column(u'user', 'curr_loc')
    op.add_column(u'location', sa.Column('longitude', sa.FLOAT(), nullable=True))
    op.add_column(u'location', sa.Column('id', sa.INTEGER(), nullable=False))
    op.add_column(u'location', sa.Column('latitude', sa.FLOAT(), nullable=True))
    op.drop_column(u'location', 'long_')
    op.drop_column(u'location', 'loc_id')
    op.drop_column(u'location', 'lat_')
    op.drop_table('user_locations')
    # ### end Alembic commands ###
