

db.accounts.ensureIndex({id:1},{unique:true});
db.sessions.ensureIndex({hash:1},{unique:true});
db.sessions.ensureIndex({account:1});
db.tutor.ensureIndex({account:1},{unique:true});
db.pupil.ensureIndex({account:1},{unique:true});
db.persons.ensureIndex({account:1},{unique:true});


