import React from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import { CreditCardIcon, HeartIcon, LogOutIcon, MapPinIcon, PackageIcon, UserIcon } from 'lucide-react';
import { useStore } from '../../contexts/StoreContext';
import { orders, user } from '../../data/account';

export const accountTabs = [
{ id: 'profile', label: 'Profile', icon: UserIcon },
{ id: 'orders', label: 'Order History', icon: PackageIcon },
{ id: 'addresses', label: 'Addresses', icon: MapPinIcon },
{ id: 'wishlist', label: 'Wishlist', icon: HeartIcon },
{ id: 'payments', label: 'Payment Methods', icon: CreditCardIcon }];


export function AccountShell({ active, children }: {active: string;children: React.ReactNode;}) {
  const { wishlist, setSignedIn } = useStore();
  const navigate = useNavigate();
  const inTransit = orders.filter((o) => o.status !== 'Delivered').length;

  return (
    <div className="bg-white">
      <header className="bg-cream">
        <div className="mx-auto flex max-w-site flex-col gap-6 px-5 py-10 md:flex-row md:items-center md:justify-between md:px-8 md:py-14">
          <div className="flex items-center gap-5">
            <span className="flex h-16 w-16 shrink-0 items-center justify-center rounded-full bg-ink font-serif text-[22px] text-white" aria-hidden="true">
              {user.firstName[0]}
              {user.lastName[0]}
            </span>
            <div>
              <h1 className="font-serif text-[28px] leading-tight md:text-[36px]">Peace be with you, {user.firstName}.</h1>
              <p className="mt-1 text-[13px] text-stone">{user.email} · Member since {user.memberSince}</p>
            </div>
          </div>
          <dl className="flex gap-8 text-[13px]">
            <div>
              <dt className="text-stone">Orders</dt>
              <dd className="mt-0.5 text-[20px] font-medium">{orders.length}</dd>
            </div>
            <div>
              <dt className="text-stone">On the way</dt>
              <dd className="mt-0.5 text-[20px] font-medium">{inTransit}</dd>
            </div>
            <div>
              <dt className="text-stone">Saved</dt>
              <dd className="mt-0.5 text-[20px] font-medium">{wishlist.length}</dd>
            </div>
          </dl>
        </div>
      </header>

      <div className="mx-auto grid max-w-site gap-8 px-5 py-8 md:px-8 md:py-14 lg:grid-cols-[240px_1fr] lg:gap-16">
        <nav aria-label="Account" className="-mx-5 border-b border-hairline px-5 lg:mx-0 lg:border-0 lg:px-0">
          <ul className="scrollbar-none flex gap-6 overflow-x-auto lg:sticky lg:top-28 lg:flex-col lg:gap-1">
            {accountTabs.map(({ id, label, icon: Icon }) =>
            <li key={id} className="shrink-0">
                <NavLink
                to={`/account/${id}`}
                className={`flex items-center gap-3 whitespace-nowrap border-b-2 pb-3 text-[14px] transition-colors lg:border-b-0 lg:border-l-2 lg:py-2.5 lg:pl-4 ${
                active === id ? 'border-ink font-medium text-ink' : 'border-transparent text-ink/60 hover:text-ink'}`
                }>
                
                  <Icon className="hidden h-4 w-4 lg:block" strokeWidth={1.5} />
                  {label}
                </NavLink>
              </li>
            )}
            <li className="shrink-0 lg:mt-6 lg:border-t lg:border-hairline lg:pt-6">
              <button
                onClick={() => {
                  setSignedIn(false);
                  navigate('/login');
                }}
                className="flex items-center gap-3 whitespace-nowrap pb-3 text-[14px] text-stone transition-colors hover:text-ink lg:py-2.5 lg:pl-4">
                
                <LogOutIcon className="hidden h-4 w-4 lg:block" strokeWidth={1.5} /> Sign out
              </button>
            </li>
          </ul>
        </nav>
        <div className="min-w-0">{children}</div>
      </div>
    </div>);

}