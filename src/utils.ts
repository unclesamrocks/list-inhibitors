export const getInhibintors = () => {
  return 'dbus-send --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.GetInhibitors';
};

export const checkInhibitor = (id: string) => {
  return `dbus-send --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager/${id} org.gnome.SessionManager.Inhibitor.GetAppId`;
};
