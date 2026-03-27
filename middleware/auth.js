export function ensureAuthenticated(req, res, next) {
    if (req.isAuthenticated()) {
        return next();
    }
    res.redirect('/login');
}

export function ensureInstituteAdmin(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (req.user.role === 'institute_admin' && req.user.institute_id) return next();
    }
    res.status(403).send('Forbidden');
}

export function ensureInstituteUser(req, res, next) {
    if (req.isAuthenticated()) {
        if (req.user.role === 'admin') return next();
        if (['teacher', 'institute_admin'].includes(req.user.role) && req.user.institute_id) return next();
    }
    res.status(403).send('Forbidden');
}

export function ensureAdmin(req, res, next) {
    if (req.isAuthenticated() && req.user.role === 'admin') return next();
    res.status(403).send('Forbidden');
}
